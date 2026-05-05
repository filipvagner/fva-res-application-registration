resource "azuread_application_registration" "this" {
  display_name = var.display_name
  description  = var.description == "" ? "Managed by Terraform." : "Managed by Terraform. ${var.description}"
}

resource "azuread_application_owner" "this" {
  for_each        = toset(var.owners)
  application_id  = azuread_application_registration.this.id
  owner_object_id = each.value
}

resource "time_rotating" "this" {
  rotation_days = var.password_expiration_in_days
}

locals {
    password_expiration_timestamp = timeadd(time_rotating.this.rfc3339, "${var.password_expiration_in_days * 24}h")
}

resource "azuread_application_password" "this" {
  application_id = azuread_application_registration.this.id
  display_name   = "secret-${formatdate("YYYY-MM-DD", time_rotating.this.rfc3339)}"
  end_date       = local.password_expiration_timestamp
  rotate_when_changed = {
    rotation = time_rotating.this.id
  }
}

resource "azuread_service_principal" "this" {
  count = var.create_service_principal ? 1 : 0

  client_id                    = azuread_application_registration.this.client_id
  app_role_assignment_required = false
  owners                       = var.owners
}

resource "azurerm_key_vault_secret" "client_secret" {
  name         = var.key_vault_secret_name != null ? var.key_vault_secret_name : "spn-${var.display_name}-clientsecret"
  value        = azuread_application_password.this.value
  content_type = "Managed by Terraform. Client secret ID: ${azuread_application_password.this.key_id}"
  expiration_date = local.password_expiration_timestamp
  key_vault_id = var.key_vault_id
}

resource "azurerm_key_vault_secret" "client_id" {
  name         = "spn-${var.display_name}-clientid"
  value        = azuread_application_registration.this.client_id
  content_type = "Managed by Terraform."
  key_vault_id = var.key_vault_id
}

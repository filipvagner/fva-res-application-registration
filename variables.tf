variable "display_name" {
  description = "The display name of the application registration."
  type        = string
}

variable "description" {
  type    = string
  default = ""
}

variable "owners" {
  description = "A list of owner object IDs for the application registration."
  type        = list(string)
}

variable "password_expiration_in_days" {
  type    = number
  default = 30
}

variable "create_service_principal" {
  type    = bool
  default = false
}

variable "key_vault_id" {
  type = string
  description = "Key Vault id to store app registration's secret"
}

variable "key_vault_secret_name" {
  type = string
  default = null
}

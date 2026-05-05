terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.71.0"
    }

    azuread = {
      source  = "hashicorp/azuread"
      version = "3.5.0"
    }

    time = {
      source  = "hashicorp/time"
      version = "0.13.1"
    }
  }
}

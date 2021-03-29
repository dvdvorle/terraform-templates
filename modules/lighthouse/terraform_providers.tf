terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 2.34"
    }
    managing-azuread = {
      source  = "hashicorp/azuread"
      version = "~> 1.4"
    }
    managed-azuread = {
      source  = "hashicorp/azuread"
      version = "~> 1.4"
    }
  }
}


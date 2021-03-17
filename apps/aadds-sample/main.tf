terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 2.34"
    }
  }
}

provider "azurerm" {
  features {}
}

data "azurerm_client_config" "current" {}

resource "azurerm_resource_group" "network" {
  name     = "networking"
  location = var.location
}

resource "azurerm_virtual_network" "vnet" {
  name                = "vnet"
  location            = var.location
  resource_group_name = azurerm_resource_group.network.name

  address_space = ["10.0.0.0/16"]
  dns_servers   = ["10.0.1.4", "10.0.1.5"]
}

resource "azurerm_subnet" "aadds" {
  name                 = "aadds-subnet"
  resource_group_name  = azurerm_resource_group.network.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "random_password" "npa_register_vm" {
  length  = 16
  special = true
}

module "aadds" {
  source = "../../modules/aadds"

  npa_register_vm_password = random_password.npa_register_vm.result
  domain_name              = var.domain_name
  subnet_id                = azurerm_subnet.aadds.id
  npa_register_vm_name     = "npa-register-vm"
}


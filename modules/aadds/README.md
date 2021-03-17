# Azure Active Directory Domain Services

## Features

Deploys a new AADDS instance into an existing subnet. Wraps an ARM template since that's currently the only supported way. Currently doesn't expose most of the ARM template settings.

## Prerequisites
- Azure subscription
  - in an AAD tenant in which you are global admin
  - without any existing AADDS instance
- Vnet and dedicated subnet, with the DNS of the VNET pointing to the x.x.x.4 and x.x.x.5 addresses of the subnet (if you're not sure about this you can let AADDS configure the DNS in the portal after provisioning it)

## Inputs
| Name | Type | Default | Description |
|------|------|---------|-------------|
| resource_group_name | string | aadds | Resource group name where AADDS will be hosted |
| location | string | westeurope | Location of the AADDS resource |
| domain_name | string | - | Full domain name of the AAD tenant which will be used for the AADDS resource |
| subnet_id | string | - | Subnet where the AADDS DC's will be added to |
| npa_register_vm_name | string | npa-register-vm | The username that will be used for the account with which vm's can be registered |
| npa_register_vm_password | string | - | The password that will be used for the account with which vm's can be registered |

## Outputs

| Name | Type | Description |
|------|------|-------------|
| npa_register_vm_upn | string | The full user principal name of the account with which vm's can be registered |

## Example usage

```terraform
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

variable "domain_name" {
  description = "Full domain name of the AAD tenant which will be used for the AADDS resource"
}

variable "location" {
  default = "westeurope"
}

module "aadds" {
  source = "./aadds"

  npa_register_vm_password = random_password.npa_register_vm.result
  domain_name              = var.domain_name
  subnet_id                = azurerm_subnet.aadds.id
  npa_register_vm_name     = "npa-register-vm"
}
```

# Virtual machine domain join

## Features

Joins a windows virtual machine to an AD DS domain

## Prerequisites
- an AD DS domain (with credentials)
- a VM

## Inputs
| Name | Type | Default | Description |
|------|------|---------|-------------|
| vm_id | string | - | Identifier of the VM which should be joined to the domain |
| domain_name | string | - | Name of the domain to join |
| domain_user_upn | string | - | UPN of the user to authenticate with the domain |
| domain_password | string | - | Password of the user to authenticate with the domain |
| ou_path | string | - | **OPTIONAL**: OU path to use during domain join |

## Outputs

Nothing

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

resource "azurerm_resource_group" "rg" {
  name     = "rg-vms"
  location = "westeurope"
}

resource "azurerm_availability_set" "main" {
  name                         = "av-main"
  location                     = azurerm_resource_group.rg.location
  resource_group_name          = azurerm_resource_group.rg.name
  managed                      = "true"
  platform_update_domain_count = 5
  platform_fault_domain_count  = 3
}

variable "subnet_id" {
  description = "ID of the Subnet in which the machines will exist"
}

module "virtual_machine" {
  source = "./virtual_machine/windows"

  resource_group_name = azurerm_resource_group.rg.name

  vm_name             = "machine"
  subnet_id           = var.subnet_id
  location            = azurerm_resource_group.rg.location
  vm_timezone         = "W. Europe Standard Time"

  availability_set_id = azurerm_availability_set.main.id
}

module "domain_join" {
  source   = "./virtual_machine/extensions/domain_join"

  vm_id           = module.virtual_machine.vm.id
  domain_name     = "example-domain.com"
  domain_user_upn = "admin@example-domain.com"
  domain_password = "Secr3tP@ss!"
}
```

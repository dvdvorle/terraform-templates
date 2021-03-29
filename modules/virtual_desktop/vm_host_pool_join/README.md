# Virtual machine session host pool join

## Features

Joins a windows virtual machine to a windows virtual desktop (WVD) session host pool

## Prerequisites
- a VM
- a WVD host pool

## Inputs
| Name | Type | Default | Description |
|------|------|---------|-------------|
| vm_id | string | - | Identifier of the VM which should be joined to the domain |
| host_pool_name | string | - | Name of the WVD host pool |
| host_pool_registration_token | string | - | WVD host pool registration token to be used to join the VM to a session host pool |

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

resource "time_rotating" "wvd_reg" {
  rotation_hours = 1
}

locals {
  wvd_token_expiration_date = timeadd(time_rotating.wvd_reg.rotation_rfc3339, "1h")
}

resource "azurerm_virtual_desktop_host_pool" "pool" {
  name                = "desktop-pool"
  location            = var.region
  resource_group_name = azurerm_resource_group.rg.name

  type               = "Pooled"
  load_balancer_type = "DepthFirst"
  registration_info {
    expiration_date = local.wvd_token_expiration_date
  }
}

module "host_pool_join" {
  source   = "./virtual_desktop/vm_host_pool_join"

  vm_id                        = module.virtual_machine.vm.id
  host_pool_name               = azurerm_virtual_desktop_host_pool.pool.name
  host_pool_registration_token = azurerm_virtual_desktop_host_pool.pool.registration_info[0].token

  depends_on = [module.domain_join, module.custom_script]
}
```

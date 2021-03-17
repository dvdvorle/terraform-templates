# Windows virtual machine

## Features

Deploys a new Windows Virtual Machine within an availability set

## Prerequisites
- an availability set
- Vnet and subnet

## Inputs
| Name | Type | Default | Description |
|------|------|---------|-------------|
| resource_group_name | string | - | Name of the Resource Group in which to deploy these resources |
| location | string | westeurope | Location of any WVD resources |
| vm_name | string | - | Name of the WVD machine(s), should include any index |
| subnet_id | string | - | ID of the Subnet in which the machines will exist |
| availability_set_id | string | - | Availability set the vm should be a part of |
| vm_size | string | Standard_F2s | **OPTIONAL**: Size of the machine to deploy |
| vm_image_id | string | - | **OPTIONAL**: ID of the custom image to use |
| vm_publisher | string | MicrosoftWindowsDesktop | **OPTIONAL**: Publisher of the vm image |
| vm_offer | string | Windows-10 | **OPTIONAL**: Offer of the vm image |
| vm_sku | string | rs5-evd | **OPTIONAL**: Sku of the vm image |
| vm_version | string | latest | **OPTIONAL**: Version of the vm image |
| vm_timezone | string | - | The vm_timezone of the vms |
| vm_storage_os_disk_size | string | 128 | **OPTIONAL**: The size of the OS disk in GB |
| local_admin_username | string | vm-admin | **OPTIONAL**: Name of the local admin account |

## Outputs

| Name | Type | Description |
|------|------|-------------|
| vm | azurerm_windows_virtual_machine | The full vm object |

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
```

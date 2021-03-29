# Lighthouse

## Features

Create a lighthouse delegation from one tenant to another

## Prerequisites
- Two Azure AAD tenants with a subscription in the one you want to delegate from
  - Owner of the subscription you want to delegate permissions from

## Inputs
| Name | Type | Default | Description |
|------|------|---------|-------------|
| resource_group_name | string | aadds | Resource group name where AADDS will be hosted |
| location | string | westeurope | Location of the AADDS resource |
| domain_name | string | - | Full domain name of the AAD tenant which will be used for the AADDS resource |
| subnet_id | string | - | Subnet where the AADDS DC's will be added to |
| npa_register_vm_name | string | npa-register-vm | The username that will be used for the account with which vm's can be registered |
| npa_register_vm_password | string | - | The password that will be used for the account with which vm's can be registered |

| location | string | westeurope | Azure region where all resources will be located |
| group_authorizations | list([authorization](#authorization)) | - | List of group names of the managing tenant, with the roles they should be assigned in the current tenant |
| service_principal_authorizations | list([authorization](#authorization)) | - | List of service principal display names of the managing tenant, with the roles they should be assigned in the current tenant |
| scope | string | - | The scope (subscription/management group) to which the permissions should be applied |
| definition_name | string | - | The name of the lighthouse definition |
| definition_description | string | - | The description of the lighthouse definition |

### group_authorization
```terraform
object({
  principal_name = string
  role_name      = string
  reason         = string
})
```
## Outputs

None

## Example usage

```terraform
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>2.51"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "~>1.4"
    }
  }
}

provider "azurerm" {
  features {}
}

provider "azuread" {
}

provider "azuread" {
  alias     = "managing"
  tenant_id = "<tenant-id-guid>"
}

data "azurerm_subscription" "current" {}

locals {
  group_auths = [
    {
      principal_name = "Security department"
      role_name      = "Reader"
      reason         = "For auditing purposes"
    }
  ]
  sp_auths    = [
    {
      principal_name = "sp-azdo"
      role_name      = "Contributor"
      reason         = "So Azure DevOps can deploy stuff"
    }
  ]
}

module "lighthouse" {
  source = "../../modules/lighthouse"

  group_authorizations             = local.group_auths
  service_principal_authorizations = local.sp_auths
  scope                            = data.azurerm_subscription.current.id
  definition_name                  = "lh-definition"
  definition_description           = "Some group in the managing tenant get some rights"

  providers = {
    managed-azuread  = azuread
    managing-azuread = azuread.managing
  }
}
```

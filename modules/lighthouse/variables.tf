variable "location" {
  description = "Azure region where all resources will be located"
  type        = string
  default     = "westeurope"
}

variable "group_authorizations" {
  description = "List of group names of the managing tenant, with the roles they should be assigned in the current tenant"
  type = list(object({
    principal_name = string
    role_name      = string
    reason         = string
  }))
}

variable "service_principal_authorizations" {
  description = "List of service principal display names of the managing tenant, with the roles they should be assigned in the current tenant"
  type = list(object({
    principal_name = string
    role_name      = string
    reason         = string
  }))
}

variable "scope" {
  description = "The scope (subscription/management group) to which the permissions should be applied"
  type        = string
}

variable "definition_name" {
  description = "The name of the lighthouse definition"
  type        = string
}

variable "definition_description" {
  description = "The description of the lighthouse definition"
  type        = string
}

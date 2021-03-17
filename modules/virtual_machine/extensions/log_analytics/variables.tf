variable "vm_id" {
  description = "Identifier of the VM which for which log_analytics should be enabled"
  type        = string
}

variable "log_analytics_workspace_id" {
  description = "Workspace ID of the Log Analytics Workspace to associate the VMs with"
  type        = string
}

variable "log_analytics_workspace_primary_shared_key" {
  description = "Primary Shared Key of the Log Analytics Workspace to associate the VMs with"
  type        = string
}

variable "vm_id" {
  description = "Identifier of the VM which for which log_analytics should be enabled"
  type        = string
}

variable "script_fileuris" {
  description = "File URIs to be consumed by the custom script extension"
  type        = list(string)
}

variable "command" {
  description = "Command for the custom script extension to run"
  type        = string
}

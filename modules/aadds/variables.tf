variable "resource_group_name" {
  description = "Resource group name where AADDS will be hosted"
  default     = "aadds"
}

variable "location" {
  description = "Location of the AADDS resource"
  default     = "westeurope"
}

variable "domain_name" {
  description = "Full domain name of the AAD tenant which will be used for the AADDS resource"
}

variable "subnet_id" {
  description = "Subnet where the AADDS DC's will be added to"
}

variable "npa_register_vm_name" {
  default     = "npa-register-vm"
  description = "The username that will be used for the account with which vm's can be registered"
  type        = string
}

variable "npa_register_vm_password" {
  description = "The password that will be used for the account with which vm's can be registered"
  type        = string
  sensitive   = true
}

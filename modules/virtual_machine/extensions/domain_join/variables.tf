variable "vm_id" {
  description = "Identifier of the VM which should be joined to the domain"
  type        = string
}

variable "domain_name" {
  description = "Name of the domain to join"
  type        = string
}

variable "domain_user_upn" {
  description = "UPN of the user to authenticate with the domain"
  type        = string
}

variable "domain_password" {
  description = "Password of the user to authenticate with the domain"
  type        = string
  sensitive   = true
}

variable "ou_path" {
  description = "**OPTIONAL**: OU path to use during domain join"
  type        = string
}

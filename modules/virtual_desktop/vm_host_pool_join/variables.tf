variable "vm_id" {
  description = "Identifier of the VM which should be joined to the domain"
  type        = string
}

variable "host_pool_name" {
  description = "Name of the WVD host pool"
  type        = string
}

variable "host_pool_registration_token" {
  description = "WVD host pool registration token to be used to join the VM to a session host pool"
  type        = string
}

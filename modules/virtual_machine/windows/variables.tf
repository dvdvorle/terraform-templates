variable "resource_group_name" {
  description = "Name of the Resource Group in which to deploy these resources"
  type        = string
}

variable "location" {
  description = "Location of any WVD resources"
  type        = string
  default     = "westeurope"
}

variable "vm_name" {
  description = "Name of the WVD machine(s), should include any index"
  type        = string
}

variable "subnet_id" {
  description = "ID of the Subnet in which the machines will exist"
  type        = string
}

variable "availability_set_id" {
  description = "Availability set the vm should be a part of"
  type        = string
}

variable "vm_size" {
  description = "**OPTIONAL**: Size of the machine to deploy"
  type        = string
  default     = "Standard_F2s"
}

variable "vm_image_id" {
  description = "**OPTIONAL**: ID of the custom image to use"
  type        = string
  default     = ""
}

variable "vm_publisher" {
  description = "**OPTIONAL**: Publisher of the vm image"
  type        = string
  default     = "MicrosoftWindowsDesktop"
}

variable "vm_offer" {
  description = "**OPTIONAL**: Offer of the vm image"
  type        = string
  default     = "Windows-10"
}

variable "vm_sku" {
  description = "**OPTIONAL**: Sku of the vm image"
  type        = string
  default     = "rs5-evd"
}

variable "vm_version" {
  description = "**OPTIONAL**: Version of the vm image"
  type        = string
  default     = "latest"
}

variable "vm_timezone" {
  description = "The vm_timezone of the vms"
  type        = string
}

variable "vm_storage_os_disk_size" {
  description = "**OPTIONAL**: The size of the OS disk in GB"
  type        = string
  default     = "128"
}

variable "local_admin_username" {
  description = "**OPTIONAL**: Name of the local admin account"
  type        = string
  default     = "vm-admin"
}

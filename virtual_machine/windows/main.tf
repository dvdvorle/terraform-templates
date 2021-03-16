terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 2.34"
    }
  }
}

resource "random_password" "local_password" {
  length           = 16
  special          = true
  min_special      = 2
  override_special = "*!@#?"
}

resource "azurerm_network_interface" "vm" {
  name                = "${var.vm_name}-nic"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "${var.vm_name}-nic-01"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "dynamic"
  }
}

resource "azurerm_windows_virtual_machine" "vm" {
  name                = var.vm_name
  location            = var.location
  resource_group_name = var.resource_group_name

  admin_username = var.local_admin_username
  admin_password = random_password.local_password.result

  network_interface_ids = [azurerm_network_interface.vm.id]
  size                  = var.vm_size
  availability_set_id   = var.availability_set_id

  os_disk {
    name                 = lower(var.vm_name)
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
    disk_size_gb         = var.vm_storage_os_disk_size
  }

  provision_vm_agent       = true
  enable_automatic_updates = true
  timezone                 = var.vm_timezone

  source_image_id = var.vm_image_id != "" ? var.vm_image_id : null

  dynamic "source_image_reference" {
    for_each = var.vm_image_id == "" ? [1] : []
    content {
      publisher = var.vm_publisher
      offer     = var.vm_offer
      sku       = var.vm_sku
      version   = var.vm_version
    }
  }
}

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 2.34"
    }
  }
}

locals {
  script_fileuris = join("\",\"", var.script_fileuris)
}

resource "azurerm_virtual_machine_extension" "custom_script_extensions" {
  name                 = "custom_script_extensions"
  virtual_machine_id   = var.vm_id
  publisher            = "Microsoft.Compute"
  type                 = "CustomScriptExtension"
  type_handler_version = "1.9"

  lifecycle {
    ignore_changes = [
      settings,
    ]
  }

  settings = <<-SETTINGS
  {
    "fileUris": ["${local.script_fileuris}"],
    "commandToExecute": "${var.command}"
  }
  SETTINGS
}


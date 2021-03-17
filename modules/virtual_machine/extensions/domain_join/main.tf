terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 2.34"
    }
  }
}

resource "azurerm_virtual_machine_extension" "domain_join" {
  name                       = "domainJoin"
  virtual_machine_id         = var.vm_id
  publisher                  = "Microsoft.Compute"
  type                       = "JsonADDomainExtension"
  type_handler_version       = "1.3"
  auto_upgrade_minor_version = true

  lifecycle {
    ignore_changes = [
      settings,
      protected_settings,
    ]
  }

  settings = <<-SETTINGS
  {
      "Name": "${var.domain_name}",
      "OUPath": "${var.ou_path}",
      "User": "${var.domain_user_upn}",
      "Restart": "true",
      "Options": "3"
  }
  SETTINGS

  protected_settings = <<-PROTECTED_SETTINGS
  {
         "Password": "${var.domain_password}"
  }
  PROTECTED_SETTINGS
}

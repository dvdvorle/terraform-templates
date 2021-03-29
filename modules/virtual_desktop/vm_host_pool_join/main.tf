terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 2.34"
    }
  }
}

resource "azurerm_virtual_machine_extension" "additional_session_host_dscextension" {
  name                       = "wvd_dsc"
  virtual_machine_id         = var.vm_id
  publisher                  = "Microsoft.Powershell"
  type                       = "DSC"
  type_handler_version       = "2.73"
  auto_upgrade_minor_version = true

  settings = <<-SETTINGS
  {
    "modulesUrl": "https://wvdportalstorageblob.blob.core.windows.net/galleryartifacts/Configuration_1-25-2021.zip",
    "configurationFunction": "Configuration.ps1\\AddSessionHost",
    "properties": {
      "hostPoolName": "${var.host_pool_name}",
      "registrationInfoToken": "${var.host_pool_registration_token}",
      "aadJoin": false
    }
  }
  SETTINGS
}


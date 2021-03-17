terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 2.34"
    }
  }
}

resource "azurerm_virtual_machine_extension" "log_analytics" {
  name = "LogAnalytics"

  virtual_machine_id         = var.vm_id
  publisher                  = "Microsoft.EnterpriseCloud.Monitoring"
  type                       = "MicrosoftMonitoringAgent"
  type_handler_version       = "1.0"
  auto_upgrade_minor_version = true

  settings = <<-SETTINGS
  {
    "workspaceId": "${var.log_analytics_workspace_id}"
  }
  SETTINGS

  protected_settings = <<-PROTECTEDSETTINGS
  {
      "workspaceKey": "${var.log_analytics_workspace_primary_shared_key}"
  }
  PROTECTEDSETTINGS
}

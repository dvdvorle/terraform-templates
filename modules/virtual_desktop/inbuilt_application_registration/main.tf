locals {
  escaped_file_path = replace(var.file_path, "\\", "\\\\")
  escaped_icon_path = replace(var.icon_path, "\\", "\\\\")
}

resource "azurerm_resource_group_template_deployment" "wvd_application" {
  name                = "${var.application_group_name}-${var.name}"
  resource_group_name = var.resource_group_name
  deployment_mode     = "Incremental"
  template_content    = <<-TEMPLATE
  {
    "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
    "contentVersion": "1.0.0.0",
    "parameters": {},
    "variables": {},
    "resources": [
      {
        "type": "Microsoft.DesktopVirtualization/applicationgroups/applications",
        "apiVersion": "2021-02-01-preview",
        "name": "${var.application_group_name}/${var.name}",
        "properties": {
          "friendlyName": "${var.friendly_name}",
          "filePath": "${local.escaped_file_path}",
          "commandLineSetting": "${var.args == "" ? "DoNotAllow" : "Require"}",
          "commandLineArguments": "${var.args}",
          "showInPortal": true,
          "iconPath": "${local.escaped_icon_path}",
          "iconIndex": ${var.icon_index},
          "applicationType": "Inbuilt"
        }
      }
    ]
  }
  TEMPLATE
}


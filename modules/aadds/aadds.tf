terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 2.34"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "aadds" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_network_security_group" "aadds" {
  name                = "aadds-nsg"
  location            = var.location
  resource_group_name = azurerm_resource_group.aadds.name

  security_rule {
    name                       = "AllowRD"
    priority                   = 201
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "CorpNetSaw"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "AllowPSRemoting"
    priority                   = 301
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "5986"
    source_address_prefix      = "AzureActiveDirectoryDomainServices"
    destination_address_prefix = "*"
  }
}

resource "azurerm_subnet_network_security_group_association" "aadds" {
  subnet_id                 = var.subnet_id
  network_security_group_id = azurerm_network_security_group.aadds.id
}

resource "azuread_service_principal" "aadds" {
  application_id = "2565bd9d-da50-47d4-8b85-4c97f669dc36"
}

resource "azurerm_resource_group_template_deployment" "aadds" {
  name                = "aadds"
  resource_group_name = azurerm_resource_group.aadds.name
  deployment_mode     = "Incremental"

  depends_on = [azuread_service_principal.aadds]

  template_content = <<-TEMPLATE
  {
    "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
    "contentVersion": "1.0.0.0",
    "parameters": {},
    "variables": {},
    "resources": [
      {
        "name": "${var.domain_name}",
        "type": "Microsoft.AAD/domainServices",
        "apiVersion": "2020-01-01",
        "location": "${var.location}",
        "tags": {},
        "properties": {
          "domainName": "${var.domain_name}",
          "domainConfigurationType": "FullySynced",
          "sku": "Standard",
          "replicaSets": [
            {
              "location": "${var.location}",
              "subnetId": "${var.subnet_id}"
            }
          ],
          "ldapsSettings": {
            "ldaps": "Disabled"
          },
          "domainSecuritySettings": {
            "ntlmV1": "Enabled",
            "tlsV1": "Enabled",
            "syncNtlmPasswords": "Enabled"
          },
          "filteredSync": "Disabled",
          "notificationSettings": {
            "notifyGlobalAdmins": "Enabled",
            "notifyDcAdmins": "Enabled",
            "additionalRecipients": []
          }
        }
      }
    ]
  }
  TEMPLATE
}

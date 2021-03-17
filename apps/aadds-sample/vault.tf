resource "azurerm_resource_group" "kv" {
  name     = "vault"
  location = var.location
}

resource "azurerm_key_vault" "kv" {
  name                = "keyvault-dvdvorle"
  location            = var.location
  resource_group_name = azurerm_resource_group.kv.name

  tenant_id                  = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days = 7
  sku_name                   = "standard"

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    secret_permissions = [
      "Get", "List", "Set", "Delete", "Purge", "Recover"
    ]
  }
}

resource "azurerm_key_vault_secret" "npa_register_vm_upn" {
  name         = "npa-register-vm-upn"
  value        = module.aadds.npa_register_vm_upn
  key_vault_id = azurerm_key_vault.kv.id
}

resource "azurerm_key_vault_secret" "npa_register_vm_password" {
  name         = "npa-register-vm-password"
  value        = random_password.npa_register_vm.result
  key_vault_id = azurerm_key_vault.kv.id
}

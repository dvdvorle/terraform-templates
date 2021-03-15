resource "azuread_group" "aadds_admin" {
  display_name = "AAD DC Administrators"
}

resource "azuread_user" "npa_register_vm" {
  user_principal_name = "${var.npa_register_vm_name}@${var.domain_name}"
  display_name        = "NPA domain join"
  password            = var.npa_register_vm_password

  # Provision the user after AADDS so the password will be synced
  depends_on = [azurerm_resource_group_template_deployment.aadds]
}

resource "azuread_group_member" "npa_register_vm_aadadmin" {
  group_object_id  = azuread_group.aadds_admin.id
  member_object_id = azuread_user.npa_register_vm.id
}


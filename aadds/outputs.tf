output "npa_register_vm_upn" {
  value       = azuread_user.npa_register_vm.user_principal_name
  description = "The full user principal name of the account with which vm's can be registered"
}

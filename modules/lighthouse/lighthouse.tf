data "azurerm_role_definition" "roles" {
  for_each = setunion(var.group_authorizations[*].role_name, var.service_principal_authorizations[*].role_name)

  name = each.value
}

data "azuread_group" "managing" {
  for_each = toset(var.group_authorizations[*].principal_name)

  display_name     = each.value
  security_enabled = true

  provider = managing-azuread
}

data "azuread_service_principal" "managing" {
  for_each = toset(var.service_principal_authorizations[*].principal_name)

  display_name = each.value

  provider = managing-azuread
}

locals {
  group_authorizations = [
    for auth in var.group_authorizations : merge({
      principal_id = data.azuread_group.managing[auth.principal_name].object_id
    }, auth)
  ]
  service_principal_authorization = [
    for auth in var.service_principal_authorizations : merge({
      principal_id = data.azuread_service_principal.managing[auth.principal_name].object_id
    }, auth)
  ]
  roles = {
    # The id and role_definition_id both give '/providers/Microsoft..../xxxx-xxx-xxx', we only need the xxxx-xxx-xxx part
    for role in data.azurerm_role_definition.roles : role.name => regex("[^/]*$", role.id)
  }
  authorizations = [
    for auth in setunion(local.group_authorizations, local.service_principal_authorization) : merge({
      role_id = local.roles[auth.role_name]
    }, auth)
  ]
}

data "azuread_client_config" "managing" {
  provider = managing-azuread
}

resource "azurerm_lighthouse_definition" "scope" {
  name               = var.definition_name
  description        = var.definition_description
  managing_tenant_id = data.azuread_client_config.managing.tenant_id

  # This seems to be needed, but this attribute isn't documentated (as of 2.51)
  scope = var.scope

  dynamic "authorization" {
    for_each = local.authorizations
    content {
      principal_id           = authorization.value.principal_id
      principal_display_name = authorization.value.principal_name
      role_definition_id     = authorization.value.role_id
    }
  }
}

resource "azurerm_lighthouse_assignment" "scope" {
  scope                    = var.scope
  lighthouse_definition_id = azurerm_lighthouse_definition.scope.id
}


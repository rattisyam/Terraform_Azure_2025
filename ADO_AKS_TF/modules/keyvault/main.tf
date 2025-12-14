# Retrieve information about the current Azure client configuration
data "azurerm_client_config" "current" {}

# Create an Azure Key Vault
resource "azurerm_key_vault" "kv" {
  name                        = var.key_vault_name
  location                    = var.location
  resource_group_name         = var.resource_group_name
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  sku_name                    = "standard"
  soft_delete_retention_days = 7
  purge_protection_enabled    = false
  enabled_for_disk_encryption = true
  
}

# Grant SP access to secrets in Key Vault
resource "azurerm_key_vault_access_policy" "sp_kv_policy" {
  key_vault_id = azurerm_key_vault.kv.id
  tenant_id    = var.service_principal_tenant_id
  object_id    = var.service_principal_object_id

  secret_permissions = [
    "Get",
    "List",
    "Set",
    "Delete"
  ]
  
}


#providing terraform-sp to read the secrets
resource "azurerm_key_vault_access_policy" "loginuser_sp_kv_policy_read" {
  key_vault_id = azurerm_key_vault.kv.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = data.azurerm_client_config.current.object_id 

  secret_permissions = [
    "Get",
    "List",
    "Set",
    "Delete"
  ]

}
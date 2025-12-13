#printining key vault id
output "key_vault_id" {
  description = "The ID of the Key Vault."
  value       = azurerm_key_vault.kv.id
}
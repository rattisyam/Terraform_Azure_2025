variable "location" {
  description = "The Azure region where the AKS cluster will be deployed."
  type        = string
  
}

variable "key_vault_name" {
  description = "keyvault name"
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group in which to create the AKS cluster."
  type        = string
  
}

variable "service_principal_name" {
  description = "The Service Principal name for AKS to access the Key Vault."
  type        = string
  
}

variable "service_principal_object_id" {}
variable "service_principal_tenant_id" {}

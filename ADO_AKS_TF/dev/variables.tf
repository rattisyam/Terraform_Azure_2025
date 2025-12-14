variable "resource_group_name" {
  description = "The name of the resource group in which to create the AKS cluster."
  type        = string
  
}

variable "location" {
  description = "The Azure region where the resource group will be created."
  type        = string
  default = "canadacentral"
  
}

variable "service_principal_name" {
  description = "The name of the service principal to be created for AKS."
  type        = string  
  
}

variable "key_vault_name" {
  description = "The name of the AKS cluster to be created."
  type        = string  
  
}


variable "sub_id" {
  description = "The subscription ID where resources will be created."
  type        = string
  default = "f28577aa-ecad-4b8d-a9b7-ee289e3a749c"
  
}

variable "node_pool_name" {
  
}
variable "cluster_name" {
  
}
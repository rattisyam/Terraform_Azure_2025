variable "location" {
  description = "The Azure region where the AKS cluster will be deployed."
  type        = string
  
}

variable "resource_group_name" {
  description = "The name of the resource group in which to create the AKS cluster."
  type        = string
  
}

variable "client_id" {
  description = "The client ID of the service principal for the AKS cluster."
  type        = string
  
}

variable "client_secret" {
  description = "The client secret of the service principal for the AKS cluster."
  type        = string
  sensitive = true
  
}

variable "ssh_public_key_path" {
  description = "The file path to the SSH public key for Linux nodes."
  type        = string
  default = "~/.ssh/id_rsa.pub"
  
}

variable "service_principal_name" {
  description = "The name of the service principal to be used for AKS."
  type        = string  
  
}
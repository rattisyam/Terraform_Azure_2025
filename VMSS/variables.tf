variable "resource_group_name" {
  description = "The name of the resource group in which to create the resources."
  type        = string
  default     = "myResourceGroup1"

}

variable "location" {
  description = "The Azure region where the resource group will be created."
  type        = string
  default     = "canadacentral"

}

variable "vnet_name" {
  description = "The name of the virtual network."
  type        = string
  default     = "myVnet"

}

variable "vnet_address_space" {
  description = "The address space for the virtual network."
  type        = string
  default     = "10.0.0.0/16"

}

variable "subnet1_name" {
  description = "The name of the subnet."
  type        = string
  default     = "App_Subnet"

}

variable "nsg_name" {
  description = "name of nsg"
  type        = string
  default     = "app_nsg"

}

variable "lb_pub_ip" {
  description = "Public IP for LB to access from outside"
  type        = string
  default     = "app_lb_pub_ip"

}

variable "app_lb" {
  description = "Application LB name"
  type        = string
  default     = "apploadbalancer"
}

variable "environment" {
  description = "Deployment Environment Name(Dev,Stage,Prod)"
  type        = string
  default     = "dev"
  
}

variable "vmss_vm_size" { #it should be based on the environment selection  
  description = "Size of the VM in the VMSS"
  type        = map(string)
  default     = {
    dev  = "Standard_B1s"
    prod = "Standard_D2s_v4"
    stage = "Standard_B2s"
  }
  
}


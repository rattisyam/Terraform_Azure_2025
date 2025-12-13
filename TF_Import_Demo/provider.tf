#terraform azure rm provider details
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.8.0"
    }
  }
}
provider "azurerm" {
  features {}
   subscription_id = "f28577aa-ecad-4b8d-a9b7-ee289e3a749c"
}

#terraform provider configuration for azurerm
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.8.0"
    }
  }

  required_version = ">= 1.9.0" #minimum terraform version required to run the tf files

}


#configure the provider
provider "azurerm" {
  features {}
}

#terraform provider configurtion for azurerm
terraform {
    required_providers {
      azurerm= {
        source  = "hashicorp/azurerm"
        version = "~> 4.12.0"
      }
    }
    required_version = ">= 1.9.0" #minimum terraform version required to run the tf files
}

provider "azurerm" {
  features {}
}
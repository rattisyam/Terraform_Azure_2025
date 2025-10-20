terraform {
  backend "azurerm" {
    resource_group_name  = "DoDevops"
    storage_account_name = "learningterraformbackend"
    container_name       = "tfstate"
    key                  = "webapp.terraform.tfstate"
  }

}



terraform {
    backend "azurerm" {
        resource_group_name  = "ado-terraform-state-rg"
        storage_account_name = "tfdevbackend2025syam"
        container_name       = "tfstate"
        key                  = "dev.terraform.tfstate"
    }
}

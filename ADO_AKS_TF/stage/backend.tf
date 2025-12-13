terraform {
    backend "azurerm" {
        resource_group_name  = "ado-terraform-state-rg"
        storage_account_name = "tfstagebackend2025syam"
        container_name       = "tfstate"
        key                  = "stage.terraform.tfstate"
    }
}

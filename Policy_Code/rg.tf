#creationg resource group
resource "azurerm_resource_group" "policy_rg" {
  name     = "policy_rg"
  location = "westeurope"
  tags = {
    Department = "IT"
    Project    = "TerraformDemo"
  }

}

resource "azurerm_resource_group" "policy_rg2" {
  name     = "policy_rg2"
  location = "westeurope"
  tags = {
    Department = "IT"
    Project    = "TerraformDemo"
  }

}
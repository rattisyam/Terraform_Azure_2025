#creating resource group
resource "azurerm_resource_group" "rgimportdemo" {
  name     = "terraformimportdemo"
  location = "canadacentral"
}

#tf file to create app service plan
resource "azurerm_service_plan" "appserviceplanimportdemo" {
  name                = "terraformimportSP"
  location            = azurerm_resource_group.rgimportdemo.location
  resource_group_name = azurerm_resource_group.rgimportdemo.name
  sku_name            = "F1"
  os_type = "Linux"
}

#webapp creation linux
resource "azurerm_linux_web_app" "linuxwebappimportdemo" {
  name                = "terraformimportdemowebapp"
  location            = azurerm_resource_group.rgimportdemo.location
  resource_group_name = azurerm_resource_group.rgimportdemo.name
  service_plan_id     = azurerm_service_plan.appserviceplanimportdemo.id
  site_config {
    always_on = "false"
    ftps_state = "FtpsOnly"
      application_stack {
        java_server = "TOMCAT"
        java_server_version = "10.0"
        java_version = "17"
    }
  }

}
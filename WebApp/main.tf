#Resource group creation
resource "azurerm_resource_group" "webapprg" {
    name     = "webapprg"
    location = "canadacentral"
}


#creation of app service plan
resource "azurerm_service_plan" "appservplandemo" {
    name = var.appsvcplan_name
    location = azurerm_resource_group.webapprg.location
    os_type = "Linux"
    resource_group_name = azurerm_resource_group.webapprg.name
    sku_name =  "S1"
}

#webapp creation
resource "azurerm_linux_web_app" "linuxwebapp" {
    name=var.webapp_name
    resource_group_name = azurerm_resource_group.webapprg.name
    location = azurerm_resource_group.webapprg.location
    service_plan_id = azurerm_service_plan.appservplandemo.id
    site_config {
      
    }
}

#Actual production linux web app slot creation
resource "azurerm_linux_web_app_slot" "linuxwebappslot" {
    name = "linuxwebappslot1"
    app_service_id = azurerm_linux_web_app.linuxwebapp.id
    site_config {
      
    }
}


#provisioning source code from github to the web app for production slot
resource "azurerm_app_service_source_control" "sourcecode1" {
    app_id = azurerm_linux_web_app.linuxwebapp.id
    repo_url = "https://github.com/rattisyam/tf-sample-bg.git"
    branch = "master"  
    use_manual_integration = true
}

#provisioning source code from github to the web app for deployment slot staging slot
resource "azurerm_app_service_source_control_slot" "sourcecodeslot1" {
    repo_url = "https://github.com/rattisyam/tf-sample-bg.git"
    branch = "appServiceSlot_Working_DO_NOT_MERGE"
    slot_id = azurerm_linux_web_app_slot.linuxwebappslot.id
    use_manual_integration = true
}

#Steps to perform the Deployment slots Swap
resource "azurerm_web_app_active_slot" "activeslot" {
 slot_id = azurerm_linux_web_app_slot.linuxwebappslot.id
}
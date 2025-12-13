#getting azure ad configurations
data "azuread_client_config" "current" {}

# create Azure AD application resource
resource "azuread_application" "aks_sp_app" {
  display_name = var.service_principal_name
  owners = [data.azuread_client_config.current.object_id]
}

#create service principal for the application
resource "azuread_service_principal" "aks_sp" { 
  client_id = azuread_application.aks_sp_app.client_id
  owners = [data.azuread_client_config.current.object_id]

}

#create a resource to manage password credentials for the service principal
resource "azuread_service_principal_password" "aks_sp_password" {
  service_principal_id = azuread_service_principal.aks_sp.id
}

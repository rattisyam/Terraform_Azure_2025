#create resource grouop
resource "azurerm_resource_group" "aks_rg" {
  name     = var.resource_group_name
  location = var.location
}

#create service principal
module "serviceprincipal" {
  source = "./modules/serviceprincipal"
  service_principal_name = var.service_principal_name
  depends_on = [ azurerm_resource_group.aks_rg ]

}

resource "azurerm_role_assignment" "roleforsp" {
  principal_id   = module.serviceprincipal.service_principal_object_id
  role_definition_name = "Contributor"
  scope          = "/subscriptions/${var.sub_id}"
  depends_on = [ module.serviceprincipal ]
  
}

#create key vault
module "keyvault" {
  source = "./modules/keyvault"
  location = var.location
  key_vault_name = var.key_vault_name
  resource_group_name = var.resource_group_name
  service_principal_object_id = module.serviceprincipal.service_principal_object_id
  service_principal_tenant_id = module.serviceprincipal.service_principal_tenant_id  
  service_principal_name = var.service_principal_name
  depends_on = [ module.serviceprincipal ]
}



#create azurerm key vault secret to store client secret
resource "azurerm_key_vault_secret" "sp_client_secret" {
  name         = module.serviceprincipal.client_id
  value        = module.serviceprincipal.client_secret
  key_vault_id = module.keyvault.key_vault_id
  depends_on = [ module.keyvault ]
}

#create aks cluster
module "aks_cluster" {  
  source = "./modules/aks"
  service_principal_name = var.service_principal_name
  client_id = module.serviceprincipal.client_id
  client_secret = module.serviceprincipal.client_secret
  location = var.location
  resource_group_name = var.resource_group_name
  

  depends_on = [ azurerm_role_assignment.roleforsp, module.keyvault ]
}

resource "local_file" "kubeconfig" {
  depends_on   = [module.aks_cluster]
  filename     = "./kubeconfig"
  content      = module.aks_cluster.aks_config
  
}
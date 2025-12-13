#serviceprinicpal name output
output "service_principal_name" {
  description = "The name of the service principal created and it can be used to assign roles to user."
  value       = azuread_service_principal.aks_sp.display_name
}

#serviceprincipal object id output
output "service_principal_object_id" { 
  description = "The object ID of the service principal created and it can be used to assign roles to user."
  value       = azuread_service_principal.aks_sp.object_id
}

#serviceprincipal tenant id output
output "service_principal_tenant_id" {
  description = "The tenant ID of the service principal created and it can be used to assign roles to user."
  value       = azuread_service_principal.aks_sp.application_tenant_id
}

#client ID output
output "client_id" {
  description = "The application id of AzureAD application created."
  value       = azuread_application.aks_sp_app.client_id
}

#client secret output
output "client_secret" {
  description = "Password for service principal. This value is sensitive."
  value       = azuread_service_principal_password.aks_sp_password.value
  sensitive   = true
} 
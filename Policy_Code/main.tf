# get the subscription details
data "azurerm_subscription" "my_sub" {

}

output "subscription_name" {
    value = data.azurerm_subscription.my_sub.display_name
}


#defining allowed tags policy
resource "azurerm_policy_definition" "tags_policy" {
  name         = "allowedtagspolicy"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "Allowed Tags Policy"
  description  = "This policy ensures that a specific tag is applied to all resources."
  policy_rule = jsonencode(
    {
        if = {
            anyOf = [
                {
                    "field" = "tags[${var.allowed_tags[0]}]"
                    exists = "false"
                },
                {
                    "field" = "tags[${var.allowed_tags[1]}]"
                    exists = "false"
                }
            ]
        }
        then = {
            effect = "deny"
        }
    }
  )

}

#assigning policy to subscription
resource "azurerm_subscription_policy_assignment" "tags_policy_assignment" {
  name                 = "allowedtagspolicyassignment"
  subscription_id = data.azurerm_subscription.my_sub.id
  policy_definition_id = azurerm_policy_definition.tags_policy.id
}

#defining allowed vm sizes policy
resource "azurerm_policy_definition" "vm_sizes_policy" {
  name         = "vmsizespolicy"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "Allowed vm size Policy"
  description  = "This policy ensures that a specific tag is applied to all resources."
  policy_rule = jsonencode(
    {
        if = {
            field = "Microsoft.Compute/virtualMachines/sku.name"
            notIn = ["${var.vm_sizes[0]}", "${var.vm_sizes[1]}"]
        },
        then = {
            effect = "deny"
        }
    }
  )

}

#policy assignment for vm sizes
resource "azurerm_subscription_policy_assignment" "vm_sizes_policy_assignment" {
  name                 = "vmsizespolicyassignment"
  subscription_id = data.azurerm_subscription.my_sub.id
  policy_definition_id = azurerm_policy_definition.vm_sizes_policy.id
}

#polict definition for location
resource "azurerm_policy_definition" "location_policy" {
  name         = "locationpolicy"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "Allowed location Policy"
  description  = "This policy ensures that resources are deployed only in allowed locations."
  policy_rule = jsonencode(
    {
        if = {
            field = "location"
            notIn = ["${var.location[0]}", "${var.location[1]}", "${var.location[2]}"]
        },
        then = {
            effect = "deny"
        }
    }
  )
  
}

#location policy assignment
resource "azurerm_subscription_policy_assignment" "location_policy_assignment" {
  name                 = "locationpolicyassignment"
  subscription_id = data.azurerm_subscription.my_sub.id
  policy_definition_id = azurerm_policy_definition.location_policy.id
}
#script to create resource group and vnet
resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}

#virtual network creation
resource "azurerm_virtual_network" "vnet" {
  name                = var.vnet_name
  address_space       = [var.vnet_address_space]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  tags = {
    modified_on = local.common_tags.modified_on
  }
}

#APP subnet creation
resource "azurerm_subnet" "subnet" {
  name                 = var.subnet1_name
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

# network security group for the subnet with a rule to allow http, https and ssh traffic
resource "azurerm_network_security_group" "nsg" {
  name                = var.nsg_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

dynamic "security_rule" {  #adding dynamic block to add rules from locals.tf
    for_each = local.nsg_rules
 
    content {
      name                       = security_rule.value.name
      priority                   = security_rule.value.priority
      direction                  = security_rule.value.direction
      access                     = security_rule.value.access
      protocol                   = security_rule.value.protocol
      source_port_range          = security_rule.value.source_port_range
      destination_port_range     = security_rule.value.destination_port_range
      source_address_prefix      = security_rule.value.source_address_prefix
      destination_address_prefix = security_rule.value.destination_address_prefix
    }
  
}
  tags = {
    modified_on = local.common_tags.modified_on
  }
}

resource "azurerm_subnet_network_security_group_association" "nsg_association" {
  subnet_id                 = azurerm_subnet.subnet.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}


#random name for LB DNS name creation
resource "random_pet" "lb_hostname" {

}

# A public IP address for the load balancer
resource "azurerm_public_ip" "lb_pub_ip" {
  name                = var.lb_pub_ip
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
  zones               = ["1", "2", "3"]
  domain_name_label   = lower("${azurerm_resource_group.rg.name}-${random_pet.lb_hostname.id}")
}

# A load balancer with a frontend IP configuration and a backend address pool
resource "azurerm_lb" "app_lb" {
  name                = var.app_lb
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku                 = "Standard"
  frontend_ip_configuration {
    name                 = "AppPublicIPAddress"
    public_ip_address_id = azurerm_public_ip.lb_pub_ip.id
  }
  tags = {
    modified_on = local.common_tags.modified_on
  }

}

#backend address pool for the load balancer
resource "azurerm_lb_backend_address_pool" "lb_backend_pool" {
  name            = "AppBackendPool"
  loadbalancer_id = azurerm_lb.app_lb.id
}

#set up load balancer rule from azurerm_lb frontend ip to azurerm_lb_backend_address_pool backend ip port 80 to port 80
resource "azurerm_lb_rule" "http_rule" {
  name                           = "HTTPRule"
  loadbalancer_id                = azurerm_lb.app_lb.id
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  frontend_ip_configuration_name = azurerm_lb.app_lb.frontend_ip_configuration[0].name
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.lb_backend_pool.id]
  probe_id                       = azurerm_lb_probe.lb_probe.id
}

#setup lb health probes for backend vms
resource "azurerm_lb_probe" "lb_probe" {
  name            = "http-probe"
  loadbalancer_id = azurerm_lb.app_lb.id
  protocol        = "Http"
  port            = 80
  request_path    = "/"
}

#Allow SSH port from the NAT instance to VMs
resource "azurerm_lb_nat_rule" "ssh_lb_nat_rule" {
  name                           = "LBSSHNatRule"
  resource_group_name            = azurerm_resource_group.rg.name
  loadbalancer_id                = azurerm_lb.app_lb.id
  protocol                       = "Tcp"
  frontend_port_start            = 50001
  frontend_port_end              = 50100
  backend_port                   = 22
  frontend_ip_configuration_name = azurerm_lb.app_lb.frontend_ip_configuration[0].name

  backend_address_pool_id = azurerm_lb_backend_address_pool.lb_backend_pool.id
}

#public IP for NAT gateway  
resource "azurerm_public_ip" "nat_gw_pub_ip" {
  name                = "nat-gw-pub-ip"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
  zones               = ["1"]
}

#Create NAT gateway to enable outbound traffic from the backend pool
resource "azurerm_nat_gateway" "nat_gw" {
  name                    = "nat-gateway"
  location                = azurerm_resource_group.rg.location
  resource_group_name     = azurerm_resource_group.rg.name
  sku_name                = "Standard"
  idle_timeout_in_minutes = 10
  zones                   = ["1"]
}
#Associate the NAT gateway with the subnet
resource "azurerm_subnet_nat_gateway_association" "nat_gw_association" {
  subnet_id      = azurerm_subnet.subnet.id
  nat_gateway_id = azurerm_nat_gateway.nat_gw.id
}

#associate public IP with NAT gateway
resource "azurerm_nat_gateway_public_ip_association" "nat_gw_pub_ip_association" {
  nat_gateway_id       = azurerm_nat_gateway.nat_gw.id
  public_ip_address_id = azurerm_public_ip.nat_gw_pub_ip.id
}

#output the resource group name and location
output "resource_group_name" {
  value = azurerm_resource_group.rg.name
}
output "location" {
  value = azurerm_resource_group.rg.location
}
output "vnet_name" {
  value = azurerm_virtual_network.vnet.name
}
output "subnet_name" {
  value = azurerm_subnet.subnet.name
}
output "nsg_name" {
  value = azurerm_network_security_group.nsg.name
}

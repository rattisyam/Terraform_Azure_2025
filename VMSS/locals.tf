locals {
    common_tags = {
      
        modified_on = formatdate("YYYY-MM-DD", timestamp())        
    }

    vm_size = lookup(var.vmss_vm_size, var.environment, "Standard_B1s")

    nsg_rules = [
        {
            name                       = "allow-http"
            priority                   = 100
            direction                  = "Inbound"
            access                     = "Allow"
            protocol                   = "Tcp"
            source_port_range          = "*"
            destination_port_range     = "80"
            source_address_prefix      = "*"
            destination_address_prefix = "*"
        },
        {
            name                       = "allow-https"
            priority                   = 101
            direction                  = "Inbound"
            access                     = "Allow"
            protocol                   = "Tcp"
            source_port_range          = "*"
            destination_port_range     = "443"
            source_address_prefix      = "*"
            destination_address_prefix = "*"
        },
        {
            name                       = "allow-ssh"
            priority                   = 102
            direction                  = "Inbound"
            access                     = "Allow"
            protocol                   = "Tcp"
            source_port_range          = "*"
            destination_port_range     = "22"
            source_address_prefix      = "*"
            destination_address_prefix = "*"
        }
    ]
}
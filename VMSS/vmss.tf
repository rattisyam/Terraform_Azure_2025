#create orchastarted vmss with load balancer
resource "azurerm_orchestrated_virtual_machine_scale_set" "appvmss" {
  name                        = "tfappvmss"
  location                    = azurerm_resource_group.rg.location
  resource_group_name         = azurerm_resource_group.rg.name
  #sku_name                    = "Standard_D2s_v4"
  sku_name                    = local.vm_size
  platform_fault_domain_count = 1
  zones                       = ["1"]
  instances                   = 2
  #upgrade_mode = "Manual"
  user_data_base64 = base64encode(file("user-data.sh"))

  os_profile {
    linux_configuration {
      disable_password_authentication = false
      admin_username                  = "azureuser"
      admin_password                  = "P@ssword1234!"
      #admin_ssh_key {
      #  username   = "azureuser"
      # public_key = file(".ssh/key.pub")

    }
  }


  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-LTS-gen2"
    version   = "latest"
  }
  os_disk {
    storage_account_type = "Standard_LRS"
    caching              = "ReadWrite"
  }
  network_interface {
    name    = "appvmssnic"
    primary = true
    ip_configuration {
      name                                   = "nic_vmss_ip_config"
      primary                                = true
      subnet_id                              = azurerm_subnet.subnet.id
      load_balancer_backend_address_pool_ids = [azurerm_lb_backend_address_pool.lb_backend_pool.id]

    }
  }
  boot_diagnostics {
    storage_account_uri = ""

  }
  lifecycle {
    ignore_changes = [instances]
  }
  tags = {
    modified_on = local.common_tags.modified_on

  }

}
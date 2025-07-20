
resource "azurerm_linux_virtual_machine" "frontend" {
  name                = var.machine_name
  resource_group_name = var.rg_name
  location            = var.location
  size                = "Standard_F2"
  admin_username      = var.admin_username
  admin_password      = var.admin_password
  network_interface_ids = [data.azurerm_network_interface.nicid.id]

  disable_password_authentication = false
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = var.storage_account_type
  }

  source_image_reference {
    publisher = var.publisher
    offer     = var.offer
    sku       = var.sku
    version   = "latest"
  }

  custom_data = base64encode(<<EOF
#!/bin/bash
apt update -y
apt install nginx -y
systemctl enable nginx
systemctl start nginx
EOF
  )
}


data "azurerm_network_interface" "nicid" {
  name                = var.nic_name
  resource_group_name = var.rg_name
}
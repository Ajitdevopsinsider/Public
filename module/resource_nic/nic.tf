resource "azurerm_network_interface" "nic" {
  name                = var.nic_name
  location            = var.location
  resource_group_name = var.rg_name

  ip_configuration {
    name                          = var.ip_configuration_name
    subnet_id                     = data.azurerm_subnet.subnetid.id
    private_ip_address_allocation = var.private_ip_address_allocation
    public_ip_address_id          = data.azurerm_public_ip.pipid.id
  }
}

data "azurerm_subnet" "subnetid" {
  name                 = var.subnet_name
  virtual_network_name = var.virtual_network_name
  resource_group_name  = var.rg_name
}

data "azurerm_public_ip" "pipid" {
  name                = var.pip_name
  resource_group_name = var.rg_name
}

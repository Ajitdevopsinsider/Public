module "resource_group_name" {
  source = "../module/resource_group"

  rg_name  = "practice_rg"
  location = "centralindia"
}

module "resource_vnet" {
  depends_on    = [module.resource_group_name]
  source        = "../module/resource_vnet"
  vnet_name     = "practicevnet"
  location      = "centralindia"
  rg_name       = "practice_rg"
  address_space = ["10.0.0.0/16"]
}
module "resource_subnet1" {
  depends_on       = [module.resource_vnet]
  source           = "../module/resource_subnet"
  subnet_name      = "frantend_subnet"
  rg_name          = "practice_rg"
  vnet_name        = "practicevnet"
  address_prefixes = ["10.0.1.0/24"]
}

module "resource_subnet2" {
  depends_on       = [module.resource_vnet]
  source           = "../module/resource_subnet"
  subnet_name      = "backend_subnet"
  rg_name          = "practice_rg"
  vnet_name        = "practicevnet"
  address_prefixes = ["10.0.2.0/24"]
}

module "resource_public_ip1" {
  depends_on = [module.resource_subnet1]
  source     = "../module/resource_public_ip"
  location   = "centralindia"
  pip_name   = "frontend_pip"
  rg_name    = "practice_rg"
}

module "resource_public_ip2" {
  depends_on = [module.resource_subnet2]
  source     = "../module/resource_public_ip"
  location   = "centralindia"
  pip_name   = "backend_pip"
  rg_name    = "practice_rg"
}

module "resource_nic1" {
  depends_on                    = [module.resource_public_ip1]
  source                        = "../module/resource_nic"
  nic_name                      = "frontend_nic"
  location                      = "centralindia"
  rg_name                       = "practice_rg"
  subnet_name                   = "frantend_subnet"
  virtual_network_name          = "practicevnet"
  private_ip_address_allocation = "Dynamic"
  ip_configuration_name         = "ipconfig1"
  pip_name                      = "frontend_pip"
}

module "resource_nic2" {
  depends_on                    = [module.resource_public_ip2]
  source                        = "../module/resource_nic"
  nic_name                      = "backend_nic"
  location                      = "centralindia"
  rg_name                       = "practice_rg"
  subnet_name                   = "backend_subnet"
  virtual_network_name          = "practicevnet"
  private_ip_address_allocation = "Dynamic"
  ip_configuration_name         = "ipconfig2"
  pip_name                      = "backend_pip"
}

module "resource_vm1" {
  depends_on           = [module.resource_nic1]
  source               = "../module/resource_virtual_machine"
  machine_name         = "frontendvm"
  location             = "centralindia"
  rg_name              = "practice_rg"
  nic_name             = "frontend_nic"
  admin_username       = "adminuser1"
  admin_password       = "P@ssw0rd1234"
  storage_account_type = "Standard_LRS"
  publisher            = "Canonical"
  offer                = "0001-com-ubuntu-server-jammy"
  sku                  = "22_04-lts"
}

module "resource_vm2" {
  depends_on           = [module.resource_nic2]
  source               = "../module/resource_virtual_machine"
  machine_name         = "backendvm"
  location             = "centralindia"
  rg_name              = "practice_rg"
  nic_name             = "backend_nic"
  admin_username       = "adminuser1"
  admin_password       = "P@ssw0rd1234"
  storage_account_type = "Standard_LRS"
  publisher            = "Canonical"
  offer                = "0001-com-ubuntu-server-jammy"
  sku                  = "22_04-lts"
}

module "azurerm_key_vault" {
  depends_on = [module.resource_group_name]
  source     = "../module/azurerm_key_vault"
  key_name   = "keyvoultpractice"
  location   = "centralindia"
  rg_name    = "practice_rg"
}

# Create Dependencies
provider "azurerm" {
  version = "=2.0.0"
  features {}
}

resource "azurerm_resource_group" "test-rg" {
  name     = var.rg_name
  location = var.location
}

resource "azurerm_virtual_network" "test-vnet" {
  name                = var.vnet_name
  location            = azurerm_resource_group.test-rg.location
  resource_group_name = azurerm_resource_group.test-rg.name
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "test-subnet" {
  name                 = var.subnet_name
  resource_group_name  = azurerm_resource_group.test-rg.name
  virtual_network_name = azurerm_virtual_network.test-vnet.name
  address_prefix       = "10.0.1.0/24"
}

resource "azurerm_network_security_group" "test-nsg" {
  name                = "test-nsg"
  location            = azurerm_resource_group.test-rg.location
  resource_group_name = azurerm_resource_group.test-rg.name
}

# Create Panorama
module "panoramas" {
  source              = "../../"
  location            = var.location
  resource_group_name = azurerm_resource_group.test-rg.name
  panoramas = {
    panorama1 = {
      admin_username            = "fwadmin"
      ssh_key                   = var.ssh_key
      pan_size                  = "Standard_DS3_v2"
      subnet_id                 = azurerm_subnet.test-subnet.id
      network_security_group_id = azurerm_network_security_group.test-nsg.id
    }
    panorama2 = {
      admin_username            = "fwadmin"
      ssh_key                   = var.ssh_key
      pan_size                  = "Standard_DS3_v2"
      subnet_id                 = azurerm_subnet.test-subnet.id
      network_security_group_id = azurerm_network_security_group.test-nsg.id
    }
  }
}

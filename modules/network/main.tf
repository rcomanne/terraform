provider "azurerm" {
  version = "1.37"
}

resource "azurerm_resource_group" "rg-network" {
  name     = var.resource_group
  location = var.location_full
}

resource "azurerm_virtual_network" "vnet-rcomanne" {
  name                = "vnet-rcomanne"
  address_space       = ["10.0.0.0/16"]
  location            = var.location_full
  resource_group_name = var.resource_group

  tags = {
    environment = "Terraform Test"
  }

  depends_on = [azurerm_resource_group.rg-network]
}

resource "azurerm_subnet" "subnet-rcomanne" {
  name                 = "subnet-rcomanne"
  resource_group_name  = var.resource_group
  virtual_network_name = azurerm_virtual_network.vnet-rcomanne.name
  address_prefix       = "10.0.2.0/24"

  depends_on = [azurerm_resource_group.rg-network]
}

resource "azurerm_network_security_group" "myterraformnsg" {
  name                = "nsg-rcomanne"
  location            = var.location_full
  resource_group_name = var.resource_group

  security_rule {
    name                       = "SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  depends_on = [azurerm_resource_group.rg-network]

  tags = {
    environment = "Terraform Test"
  }
}

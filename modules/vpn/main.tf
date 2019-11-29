provider "azurerm" {
}

resource "azurerm_resource_group" "vpn-resource-group" {
  name     = var.resource_group
  location = var.location

  tags = {
    purpose     = "VPN"
    environment = "Terraform Test"
  }
}

resource "azurerm_public_ip" "vpn-pub-ip" {
  name                = "${var.resource_name}-pub-ip"
  location            = var.location
  resource_group_name = azurerm_resource_group.myterraformgroup.name
  allocation_method   = "Dynamic"

  depends_on = [azurerm_resource_group.vpn-resource-group]

  tags = {
    purpose     = "VPN"
    environment = "Terraform Test"
  }
}

resource "azurerm_network_interface" "vpn-nic" {
  name                        = "${var.resource_name}-nic"
  location                    = var.location
  resource_group_name         = azurerm_resource_group.myterraformgroup.name
  network_security_group_id   = azurerm_network_security_group.myterraformnsg.id

  ip_configuration {
    name                          = "${var.resource_name}-nic-config"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = "${azurerm_public_ip.vpn-pub-ip.id}"
  }

  depends_on = [azurerm_resource_group.vpn-resource-group]

  tags = {
    purpose     = "VPN"
    environment = "Terraform Demo"
  }
}

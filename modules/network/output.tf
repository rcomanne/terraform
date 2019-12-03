output "vnet_id" {
  value = azurerm_virtual_network.vnet-rcomanne.id
}

output "subnet_id" {
  value = azurerm_subnet.subnet-rcomanne.id
}

output "nsg_id" {
  value = azurerm_network_security_group.nsg-rcomanne.id
}



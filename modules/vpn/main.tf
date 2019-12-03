###########################################
####    Get secrets from KeyVault      ####
###########################################
data "azurerm_key_vault" "keyvault" {
  name                = "vault-terraform"
  resource_group_name = "rg-${var.environment}-${var.location}-vaults"
}

data "azurerm_key_vault_secret" "admin_username" {
  name         = "admin-username"
  key_vault_id = data.azurerm_key_vault.keyvault.id
}

data "azurerm_key_vault_secret" "admin_pub_key" {
  name         = "admin-pub-key"
  key_vault_id = data.azurerm_key_vault.keyvault.id
  #vault_uri = data.azurerm_key_vault.keyvault.vault_uri
}


###########################################
####     Create Resource Group         ####
###########################################
resource "azurerm_resource_group" "vpn-resource-group" {
  name     = var.resource_group
  location = var.location_full

  tags = {
    purpose     = "VPN"
    environment = "Terraform Test"
  }
}

###########################################
####         Create Public IP          ####
###########################################
resource "azurerm_public_ip" "vpn-pub-ip" {
  count = var.vm_count

  name                = "${var.resource_name}-pub-ip-${count.index}"
  location            = var.location_full
  resource_group_name = azurerm_resource_group.vpn-resource-group.name
  allocation_method   = "Dynamic"

  depends_on = [azurerm_resource_group.vpn-resource-group]

  tags = {
    purpose     = "VPN"
    environment = "Terraform Test"
  }
}

###########################################
####            Create NIC             ####
###########################################
resource "azurerm_network_interface" "vpn-nic" {
  count = var.vm_count

  name                        = "${var.resource_name}-nic-${count.index}"
  location                    = var.location_full
  resource_group_name         = azurerm_resource_group.vpn-resource-group.name
  network_security_group_id   = var.nsg_id

  ip_configuration {
    name                          = "${var.resource_name}-nic-config"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = "${azurerm_public_ip.vpn-pub-ip[count.index].id}"
  }

  depends_on = [azurerm_resource_group.vpn-resource-group]

  tags = {
    purpose     = "VPN"
    environment = "Terraform Demo"
  }
}

###########################################
####            Create VM              ####
###########################################
resource "azurerm_virtual_machine" "vpn-vm" {
  count = var.vm_count

  name                  = "${var.resource_name}-vm-${count.index}"
  location              = var.location_full
  resource_group_name   = azurerm_resource_group.vpn-resource-group.name
  network_interface_ids = ["${azurerm_network_interface.vpn-nic.*.id[count.index]}"]
  vm_size               = var.vm_size

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
  storage_os_disk {
    name              = "${var.resource_name}-os-disk-${count.index}"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = "${var.resource_name}-vm-${count.index}"
    admin_username = data.azurerm_key_vault_secret.admin_username.value
  }
  os_profile_linux_config {
    disable_password_authentication = true
    ssh_keys {
      path     = "/home/${data.azurerm_key_vault_secret.admin_username.value}/.ssh/authorized_keys"
      key_data = data.azurerm_key_vault_secret.admin_pub_key.value
    }
  }
  tags = {
    Rundeck-Tags = "VPN"
    environment  = "Terraform Demo"
  }

  depends_on = [
    azurerm_network_interface.vpn-nic
  ]
}

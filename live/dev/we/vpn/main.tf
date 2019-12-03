locals {
  area      = "${var.environment}-${var.location}"
  subnet_id = "/subscriptions/${var.subscription_id}/resourceGroups/rg-${local.area}-network/providers/Microsoft.Network/virtualNetworks/vnet-rcomanne/subnets/subnet-rcomanne"
}

# The provider to use
provider "azurerm" {
  subscription_id = var.subscription_id

  version = "1.37"
}

# The module(s) required for this
module "network" {
  source = "../../../../modules/network"

  location      = var.location
  location_full = var.location_full
  environment   = var.environment
}

module "vpn" {
  source = "../../../../modules/vpn"

  location      = var.location
  location_full = var.location_full
  environment   = var.environment

  # TODO: Figure out how we're gonna get the Subscription var in without writing it down somewhere...
  # Or find a better way of building/using/getting the subnet id
  subnet_id = module.network.subnet_id
  nsg_id    = module.network.nsg_id

  resource_name  = "vpn"
  resource_group = "rg-${local.area}-vpn"

  vm_size = var.vm_size
}


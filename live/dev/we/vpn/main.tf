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

  resource_group = "rg-${var.environment}-${var.location}-network"
}

module "vpn" {
  source = "../../../../modules/vpn"

  location      = var.location
  location_full = var.location_full
  environment   = var.environment

  # TODO: Figure out how we're gonna get the Subscription var in without writing it down somewhere...
  # Or find a better way of building/using/getting the subnet id
  subnet_id = "/subscriptions/${var.subscription_id}/resourceGroups/rg-${var.environment}-${var.location}-network/providers/Microsoft.Network/virtualNetworks/vnet-rcomanne/subnets/subnet-rcomanne"

  resource_name = "vpn"
  resource_group = "rg-${var.environment}-${var.location}-vpn"

  vm_size       = var.vm_size
}


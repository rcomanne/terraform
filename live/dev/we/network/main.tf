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


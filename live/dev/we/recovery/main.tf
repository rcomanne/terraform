locals {

}

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 2.85"
    }
  }
  required_version = ">= 1.0.0"
  backend "local" {
    path = "recovery.tfstate"
  }
}

# The module(s) required for this
module "recovery" {
  source = "../../../../modules/recovery"

  location      = var.location
  location_full = var.location_full
  environment   = var.environment
}


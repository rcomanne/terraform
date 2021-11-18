locals {
  resource_group = "rg-${var.environment}-${var.location}-recovery"
}

provider "azurerm" {
  features {
    key_vault {
      recover_soft_deleted_key_vaults = false
    }
  }
}

data "azurerm_client_config" "current" {}

resource "azurerm_resource_group" "rg" {
  name     = local.resource_group
  location = var.location_full
}

resource "azurerm_key_vault" "vault-seal-keys" {
  name                = "hc-vault-seal-keys"
  location            = var.location_full
  resource_group_name = local.resource_group
  sku_name            = "standard"
  soft_delete_retention_days = 7
  tenant_id           = data.azurerm_client_config.current.tenant_id

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    secret_permissions = [
      "Get", "List", "Set", "Delete", "Recover", "Backup", "Restore"
    ]
  }

  depends_on = [azurerm_resource_group.rg]
}

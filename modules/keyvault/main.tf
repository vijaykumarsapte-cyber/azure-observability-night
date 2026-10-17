/*
 * Key Vault Module
 * This module creates an Azure Key Vault for storing secrets used by the application,
 * such as database credentials, connection strings, and other sensitive information.
 */

# Generate a random string for uniqueness
resource "random_string" "kv_suffix" {
  length  = 6
  special = false
  upper   = false
}

# Azure Key Vault
resource "azurerm_key_vault" "kv" {
  name                        = var.key_vault_name != null ? var.key_vault_name : "kv${random_string.kv_suffix.result}"
  location                    = var.location
  resource_group_name         = var.resource_group_name
  enabled_for_disk_encryption = true
  tenant_id                   = var.tenant_id
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false
  enable_rbac_authorization   = false
  sku_name                    = "standard"
  tags                        = var.tags

  # Admin access policy
  access_policy {
    tenant_id = var.tenant_id
    object_id = var.object_id

    key_permissions = [
      "Get", "List", "Create", "Delete", "Update", "Recover", "Backup", "Restore", "Purge"
    ]

    secret_permissions = [
      "Get", "List", "Set", "Delete", "Recover", "Backup", "Restore", "Purge"
    ]

    certificate_permissions = [
      "Get", "List", "Create", "Delete", "Update", "Recover", "Backup", "Restore", "Import", "Purge"
    ]
  }

  # AKS user-assigned managed identity read-only access to all secrets/keys/certificates
  access_policy {
    tenant_id = var.tenant_id
    object_id = var.backend_identity_principal_id

    key_permissions = [
      "Get", "List"
    ]

    secret_permissions = [
      "Get", "List"
    ]

    certificate_permissions = [
      "Get", "List"
    ]
  }

  access_policy {
    tenant_id = var.tenant_id
    object_id = var.key_vault_csi_identity_principal_id

    secret_permissions = [
      "Get", "List"
    ]
  }

  # Network access configuration
  network_acls {
    default_action = "Allow"
    bypass         = "AzureServices"
  }
}

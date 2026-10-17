/*
 * Database Module
 * This module creates a PostgreSQL Flexible Server with:
 * - Primary server with VNet integration (private access)
 * - Initial database
 */

resource "random_password" "postgres_password" {
  length           = 16
  special          = true
  override_special = "_%@"
  min_lower        = 1
  min_upper        = 1
  min_numeric      = 1
  min_special      = 1
}

# Primary PostgreSQL Flexible Server
resource "azurerm_postgresql_flexible_server" "primary" {
  name                   = var.postgres_server_name != null ? var.postgres_server_name : "${var.resource_name_prefix}-psql"
  resource_group_name    = var.resource_group_name
  location               = var.location
  version                = var.postgres_version
  delegated_subnet_id    = var.database_subnet_ids[0]
  private_dns_zone_id    = var.private_dns_zone_id
  administrator_login    = "psqladmin"
  administrator_password = random_password.postgres_password.result
  storage_mb             = var.postgres_storage_mb
  storage_tier           = "P30" # Added based on recommended storage tier for storage_mb
  auto_grow_enabled      = true  # Added to allow storage to grow as needed
  sku_name               = var.postgres_sku_name
  tags                   = var.tags
  maintenance_window {
    day_of_week  = 0
    start_hour   = 0
    start_minute = 0
  }
  backup_retention_days = 7
  # Disable public network access
  public_network_access_enabled = false
}

# Initial Database
resource "azurerm_postgresql_flexible_server_database" "db" {
  name      = var.postgres_db_name
  server_id = azurerm_postgresql_flexible_server.primary.id
  charset   = "UTF8"
  collation = "en_US.utf8"
}

# Configure PostgreSQL parameters for performance and security
resource "azurerm_postgresql_flexible_server_configuration" "primary_ssl" {
  name      = "ssl_min_protocol_version"
  server_id = azurerm_postgresql_flexible_server.primary.id
  value     = "TLSv1.2"

  depends_on = [
    azurerm_postgresql_flexible_server.primary
  ]
}

resource "azurerm_postgresql_flexible_server_configuration" "primary_log_connections" {
  name      = "log_connections"
  server_id = azurerm_postgresql_flexible_server.primary.id
  value     = "on"

  depends_on = [
    azurerm_postgresql_flexible_server.primary
  ]
}

resource "azurerm_postgresql_flexible_server_configuration" "primary_log_checkpoints" {
  name      = "log_checkpoints"
  server_id = azurerm_postgresql_flexible_server.primary.id
  value     = "on"

  depends_on = [
    azurerm_postgresql_flexible_server.primary
  ]
}

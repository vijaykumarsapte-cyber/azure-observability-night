output "server_id" {
  description = "ID of the primary PostgreSQL server"
  value       = azurerm_postgresql_flexible_server.primary.id
}

output "server_name" {
  description = "Name of the primary PostgreSQL server"
  value       = azurerm_postgresql_flexible_server.primary.name
}

output "server_fqdn" {
  description = "FQDN of the primary PostgreSQL server"
  value       = azurerm_postgresql_flexible_server.primary.fqdn
}

output "administrator_login" {
  description = "Administrator username for PostgreSQL"
  value       = azurerm_postgresql_flexible_server.primary.administrator_login
  sensitive   = true
}

output "administrator_password" {
  description = "Administrator password for PostgreSQL"
  value       = random_password.postgres_password.result
  sensitive   = true
}

output "database_name" {
  description = "Name of the database"
  value       = azurerm_postgresql_flexible_server_database.db.name
}
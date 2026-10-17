output "private_dns_zone_id" {
  description = "ID of the private DNS zone for PostgreSQL"
  value       = azurerm_private_dns_zone.postgres.id
}

output "private_dns_zone_name" {
  description = "Name of the private DNS zone for PostgreSQL"
  value       = azurerm_private_dns_zone.postgres.name
}
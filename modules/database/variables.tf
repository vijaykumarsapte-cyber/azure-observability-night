variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "location" {
  description = "Azure region for resources"
  type        = string
}

variable "resource_name_prefix" {
  description = "Prefix for resource names"
  type        = string
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
}

variable "database_subnet_ids" {
  description = "IDs of the database subnets"
  type        = list(string)
}

variable "private_dns_zone_id" {
  description = "ID of the private DNS zone for PostgreSQL"
  type        = string
}

variable "postgres_sku_name" {
  description = "SKU name for PostgreSQL Flexible Server"
  type        = string
}

variable "postgres_version" {
  description = "PostgreSQL version"
  type        = string
}

variable "postgres_storage_mb" {
  description = "PostgreSQL storage in MB"
  type        = number
}

variable "postgres_db_name" {
  description = "PostgreSQL database name"
  type        = string
}

variable "postgres_server_name" {
  description = "Explicit PostgreSQL server name. If null, a resource_name_prefix-based name is used."
  type        = string
  default     = null
}
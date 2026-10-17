variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "vnet_id" {
  description = "ID of the Virtual Network"
  type        = string
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
}
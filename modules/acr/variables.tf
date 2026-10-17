variable "resource_group_name" {
  description = "Resource group where the ACR will be created"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "resource_name_prefix" {
  description = "Prefix to use when generating the ACR name"
  type        = string
}

variable "acr_name" {
  description = "Optional explicit ACR name. If not provided, a unique name will be generated."
  type        = string
  default     = null
}

variable "sku" {
  description = "SKU for Azure Container Registry"
  type        = string
  default     = "Standard"
}

variable "aks_principal_id" {
  description = "Principal ID of the AKS managed identity that needs AcrPull"
  type        = string
}

variable "tags" {
  description = "Tags to apply to the ACR"
  type        = map(string)
  default     = {}
}

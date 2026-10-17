variable "resource_group_name" {
  description = "Resource group where the AKS cluster will be created"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "cluster_name" {
  description = "AKS cluster name"
  type        = string
}

variable "dns_prefix" {
  description = "DNS prefix for the AKS cluster"
  type        = string
}

variable "kubernetes_version" {
  description = "Kubernetes version to deploy"
  type        = string
  default     = null
}

variable "node_count" {
  description = "Number of nodes in the default system node pool"
  type        = number
  default     = 2
}

variable "vm_size" {
  description = "VM size for AKS nodes"
  type        = string
  default     = "Standard_D2s_v4"
}

variable "subnet_id" {
  description = "Subnet resource ID for the AKS node pool"
  type        = string
}

variable "node_resource_group" {
  description = "Optional custom node resource group name"
  type        = string
  default     = null
}

variable "network_plugin" {
  description = "AKS network plugin"
  type        = string
  default     = "azure"
}

variable "network_policy" {
  description = "AKS network policy"
  type        = string
  default     = "azure"
}

variable "load_balancer_sku" {
  description = "Load balancer SKU"
  type        = string
  default     = "standard"
}

variable "outbound_type" {
  description = "Outbound type for AKS"
  type        = string
  default     = "loadBalancer"
}

variable "service_cidr" {
  description = "Service CIDR for the AKS cluster"
  type        = string
  default     = "10.2.0.0/24"
}

variable "dns_service_ip" {
  description = "DNS service IP for AKS"
  type        = string
  default     = "10.2.0.10"
}

variable "sku_tier" {
  description = "AKS SKU tier"
  type        = string
  default     = "Free"
}

variable "tags" {
  description = "Tags applied to the AKS resources"
  type        = map(string)
  default     = {}
}

output "cluster_id" {
  description = "ID of the AKS cluster"
  value       = azurerm_kubernetes_cluster.aks.id
}

output "cluster_name" {
  description = "Name of the AKS cluster"
  value       = azurerm_kubernetes_cluster.aks.name
}

output "kube_config_raw" {
  description = "Raw kubeconfig for the AKS cluster"
  value       = azurerm_kubernetes_cluster.aks.kube_config_raw
  sensitive   = true
}

output "fqdn" {
  description = "FQDN of the AKS cluster"
  value       = azurerm_kubernetes_cluster.aks.fqdn
}

output "node_resource_group" {
  description = "Node resource group created by AKS"
  value       = azurerm_kubernetes_cluster.aks.node_resource_group
}

output "identity_principal_id" {
  description = "Principal ID of the AKS control-plane user-assigned identity"
  value       = azurerm_user_assigned_identity.aks.principal_id
}

output "kubelet_identity_principal_id" {
  description = "Principal ID of the AKS kubelet user-assigned identity"
  value       = azurerm_user_assigned_identity.kubelet.principal_id
}

output "kubelet_identity_client_id" {
  description = "Client ID of the AKS kubelet user-assigned identity"
  value       = azurerm_user_assigned_identity.kubelet.client_id
}

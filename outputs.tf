output "key_vault_csi_identity_client_id" {
  description = "Client ID to use in the Key Vault CSI SecretProviderClass"
  value       = module.aks.kubelet_identity_client_id
}
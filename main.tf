# Get current Azure client config for tenant_id and object_id
data "azurerm_client_config" "current" {}


# Resource Group
resource "azurerm_resource_group" "main" {
  name     = "${var.resource_group_name}-${var.environment}"
  location = var.location
}

# Networking Module
module "networking" {
  source = "./modules/networking"

  resource_group_name    = azurerm_resource_group.main.name
  location               = var.location
  vnet_name              = var.vnet_name
  vnet_address_space     = var.vnet_address_space
  aks_subnet_prefix      = var.aks_subnet_prefix
  database_subnet_prefix = var.database_subnet_prefix
  appgw_subnet_prefix    = var.appgw_subnet_prefix
}



# # DNS Module for PostgreSQL private access
# module "dns" {
#   source = "./modules/dns"

#   resource_group_name = azurerm_resource_group.main.name
#   vnet_id             = module.networking.vnet_id

#   tags = {
#     environment = var.environment
#     managed_by  = "terraform"
#   }
# }

# # Database Module
# module "database" {
#   source = "./modules/database"

#   resource_group_name = azurerm_resource_group.main.name
#   location            = var.location
#   resource_name_prefix = "${var.resource_group_name}-${var.environment}"
#   tags = {
#     environment = var.environment
#     managed_by  = "terraform"
#   }

#   database_subnet_ids = [module.networking.database_subnet_id]
#   private_dns_zone_id = module.dns.private_dns_zone_id
#   postgres_sku_name   = var.postgres_sku_name
#   postgres_version    = var.postgres_version
#   postgres_storage_mb = var.postgres_storage_mb
#   postgres_db_name    = var.postgres_db_name
#   postgres_server_name = var.postgres_server_name
# }

# AKS Module
module "aks" {
  source = "./modules/aks"

  resource_group_name = azurerm_resource_group.main.name
  location            = var.location
  cluster_name        = var.aks_cluster_name
  dns_prefix          = var.aks_dns_prefix
  node_count          = var.aks_node_count
  vm_size             = var.aks_vm_size
  subnet_id           = module.networking.aks_subnet_id

  tags = {
    environment = var.environment
    managed_by  = "terraform"
  }
}

# Key Vault Module
module "keyvault" {
  source = "./modules/keyvault"

  resource_group_name                 = azurerm_resource_group.main.name
  location                            = var.location
  resource_name_prefix                = "${var.resource_group_name}-${var.environment}"
  key_vault_name                      = var.key_vault_name
  tenant_id                           = data.azurerm_client_config.current.tenant_id
  object_id                           = data.azurerm_client_config.current.object_id
  backend_identity_principal_id       = module.aks.identity_principal_id
  key_vault_csi_identity_principal_id = module.aks.kubelet_identity_principal_id

  tags = {
    environment = var.environment
    managed_by  = "terraform"
  }
}

# ACR Module
module "acr" {
  source = "./modules/acr"

  resource_group_name  = azurerm_resource_group.main.name
  location             = var.location
  resource_name_prefix = "${var.resource_group_name}-${var.environment}"
  acr_name             = var.acr_name
  aks_principal_id     = module.aks.kubelet_identity_principal_id

  tags = {
    environment = var.environment
    managed_by  = "terraform"
  }
}
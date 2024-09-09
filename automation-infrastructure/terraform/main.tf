provider "azurerm" {
  features {}

  subscription_id = "2fc0173e-cada-4000-82db-566c79d396db"
}

resource "azurerm_resource_group" "aks_rg" {
  name     = var.resource_group_name
  location = var.location

  tags = {
    author  = "Shramish Kafle"
    purpose = "AKS deployment"
  }
}

module "network" {
  source              = "./modules/network"
  resource_group_name = azurerm_resource_group.aks_rg.name
  location            = var.location
}

module "aks_cluster" {
  source              = "./modules/aks"
  resource_group_name = azurerm_resource_group.aks_rg.name
  location            = var.location
  subnet_id           = module.network.subnet_id
}

# Optional: Deploy in the secondary region if enabled
resource "azurerm_resource_group" "aks_rg_secondary" {
  for_each = var.enable_multi_region ? { "secondary" = "secondary" } : {}
  name     = "${var.resource_group_name}-secondary"
  location = var.secondary_location

  tags = {
    author  = "Shramish Kafle"
    purpose = "AKS secondary deployment"
  }
}


module "network_secondary" {
  for_each           = var.enable_multi_region ? { "secondary" = "secondary" } : {}
  source              = "./modules/network"
  resource_group_name = azurerm_resource_group.aks_rg_secondary[each.key].name
  location            = var.secondary_location
}

module "aks_cluster_secondary" {
  for_each           = var.enable_multi_region ? { "secondary" = "secondary" } : {}
  source              = "./modules/aks"
  resource_group_name = azurerm_resource_group.aks_rg_secondary[each.key].name
  location            = var.secondary_location
  subnet_id           = module.network_secondary[each.key].subnet_id
  depends_on          = [module.aks_cluster]
}

module "traffic_manager" {
  source              = "./modules/traffic_manager"
  resource_group_name = azurerm_resource_group.aks_rg.name
  location            = var.location

  primary_cluster_id   = "/subscriptions/2fc0173e-cada-4000-82db-566c79d396db/resourcegroups/aks-resource-group/providers/Microsoft.ContainerService/managedClusters/aks-cluster-westeurope" 
  secondary_cluster_id = "/subscriptions/2fc0173e-cada-4000-82db-566c79d396db/resourcegroups/aks-resource-group-secondary/providers/Microsoft.ContainerService/managedClusters/aks-cluster-northeurope"
  enable_multi_region  = var.enable_multi_region
  
  depends_on = [
    module.aks_cluster,
    module.aks_cluster_secondary,
  ]
}

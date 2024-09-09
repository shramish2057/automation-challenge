resource "azurerm_traffic_manager_profile" "tm_profile" {
  name                = "${var.resource_group_name}-tm"
  resource_group_name = var.resource_group_name

  dns_config {
    relative_name = "aks-ha"
    ttl           = 30
  }

  monitor_config {
    protocol = "HTTP"
    port     = 80
    path     = "/"
  }

  traffic_routing_method = "Performance"
  profile_status         = "Enabled"
}

resource "azurerm_traffic_manager_azure_endpoint" "tm_primary" {
  name                = "primary-endpoint"
  profile_id          = azurerm_traffic_manager_profile.tm_profile.id
  target_resource_id  = var.primary_cluster_id 
  priority            = 1
  weight              = 1000
}

resource "azurerm_traffic_manager_azure_endpoint" "tm_secondary" {
  count               = var.enable_multi_region ? 1 : 0
  name                = "secondary-endpoint"
  profile_id          = azurerm_traffic_manager_profile.tm_profile.id
  target_resource_id  = var.secondary_cluster_id  
  priority            = 2
  weight              = 1000
}

resource "azurerm_kubernetes_cluster" "aks" {
  name                = "${var.aks_cluster_name}-${var.location}"
  location            = var.location
  resource_group_name = var.resource_group_name
  dns_prefix          = "aksdns"

  default_node_pool {
    name            = "default"
    node_count      = var.node_count
    vm_size         = var.node_vm_size
    vnet_subnet_id  = var.subnet_id
  }

  identity {
    type = "SystemAssigned"
  }

  network_profile {
    network_plugin    = "azure"
    load_balancer_sku = "standard"
    network_policy    = "azure"
  }

  tags = {
    environment = "Terraform-managed"
  }
}

output "is_multi_region_enabled" {
  value = var.enable_multi_region
}

output "primary_aks_cluster_id" {
  value = module.aks_cluster.aks_cluster_id
}

output "secondary_aks_cluster_id" {
  value = var.enable_multi_region ? module.aks_cluster_secondary["secondary"].aks_cluster_id : "not enabled"
}

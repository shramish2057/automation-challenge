variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
}

variable "location" {
  description = "The Azure region to deploy resources"
  type        = string
}

variable "primary_cluster_id" {
  description = "The resource ID of the primary AKS cluster"
  type        = string
}

variable "secondary_cluster_id" {
  description = "The resource ID of the secondary AKS cluster"
  type        = string
  default     = null
}

variable "enable_multi_region" {
  description = "Enable multi-region deployment"
  type        = bool
  default     = true
}

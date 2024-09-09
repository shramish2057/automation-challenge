variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
  default     = "aks-resource-group"
}

variable "location" {
  description = "The Azure region to deploy resources"
  type        = string
  default     = "westeurope"
}

variable "secondary_location" {
  description = "The Azure secondary region for high availability"
  type        = string
  default     = "northeurope"
}

variable "enable_multi_region" {
  description = "Enable multi-region deployment"
  type        = bool
  default     = true
}

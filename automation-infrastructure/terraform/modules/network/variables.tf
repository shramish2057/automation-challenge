variable "vnet_name" {
  description = "The name of the virtual network"
  type        = string
  default     = "aks-vnet"
}

variable "subnet_name" {
  description = "The name of the subnet"
  type        = string
  default     = "aks-subnet"
}

variable "nsg_name" {
  description = "The name of the network security group"
  type        = string
  default     = "aks-nsg"
}

variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
}

variable "location" {
  description = "The Azure region to deploy resources"
  type        = string
}

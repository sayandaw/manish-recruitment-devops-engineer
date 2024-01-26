# variables.tf

variable "resource_group_name" {
  description = "Name of the Azure Resource Group"
  type        = string
  default     = "manish_rg"
}

variable "location" {
  description = "Location of resources"
  type        = string
  default     = "East US"
}

variable "vnet_name" {
  description = "Name of the Virtual Network"
  type        = string
  default     = "myVnet"
}

variable "subnet_name" {
  description = "Name of the Subnet"
  type        = string
  default     = "mySubnet"
}

variable "nsg_name" {
  description = "Name of the Network Security Group"
  type        = string
  default     = "myNSG"
}

variable "public_ip_name" {
  description = "Name of the Public IP"
  type        = string
  default     = "myPublicIP"
}

variable "nic_name" {
  description = "Name of the Network Interface"
  type        = string
  default     = "myNIC"
}

variable "vm_name" {
  description = "Name of the Virtual Machine"
  type        = string
  default     = "manishvmtest"
}

variable "admin_username" {
  description = "Admin username for the Virtual Machine"
  type        = string
  default     = "manish"
}

variable "admin_password" {
  description = "Admin password for the Virtual Machine"
  type        = string
  default     = "Password1234!"
}

variable "resource_group_name" {
  description = "Name of the Azure resource group"
  type        = string
  default     = "myTFResourceGroup"
}

variable "location" {
  description = "Azure region where resources are created"
  type        = string
  default     = "eastus2"
}

variable "storage_account_name" {
  description = "Globally unique name of the storage account (lowercase letters and numbers only)"
  type        = string
  default     = "mytfstorageaccount987"
}

variable "container_name" {
  description = "Name of the blob storage container"
  type        = string
  default     = "mytfcontainer987"
}

variable "virtual_network_name" {
  description = "Name of the virtual network"
  type        = string
  default     = "myTFVNet987"
}

variable "subnet_name" {
  description = "Name of the subnet"
  type        = string
  default     = "myTFSubnet987"
}

variable "azurerm_public_ip_name" {
  description = "Name of the public IP address"
  type        = string
  default     = "myTFPublicIP987"
}

variable "azurerm_network_interface_name" {
  description = "Name of the network interface"
  type        = string
  default     = "myTFNIC987"
}


variable "azurerm_linux_virtual_machine_name" {
  description = "Name of the Linux virtual machine"
  type        = string
  default     = "myTFVM987"
}
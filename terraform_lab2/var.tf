# variables.tf — inputs for Lab 4.

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
  default     = "rg-terraform-lab4"
}

variable "location" {
  description = "Azure region"
  type        = string
  default     = "East US"
}

variable "vm_size" {
  description = "VM size/SKU. B1s is the cheapest burstable size — good for learning."
  type        = string
  default     = "Standard_B1s"
}

variable "admin_username" {
  description = "Admin username for SSH login to the VM"
  type        = string
  default     = "azureuser"
}

variable "tags" {
  description = "Tags applied to all resources"
  type        = map(string)
  default = {
    environment = "learning"
    lab         = "lab4-linux-vm"
    managed_by  = "terraform"
  }
}
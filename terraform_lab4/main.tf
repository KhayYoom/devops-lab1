terraform {
  required_providers{
    azurerm = { 
        source = "hashicorp/azurerm"
        version = "~>4.0"
        }
  }
}

provider "azurerm" {
    features {}
}

resource "azurerm_resource_group" "demo_rg" {
    name   = var.rg_name
    location = var.location
}
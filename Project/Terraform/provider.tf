terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "~>4.0"
    }
  }

  backend "azurerm" {
    resource_group_name  = "rg-tfstate"
    storage_account_name = "tfstatekhayyoom"
    container_name       = "tfstate"
    key                  = "project/terraform.tfstate"
  }
}

provider "azurerm" {
  features {}
  subscription_id = "e21901bf-488a-4ded-b169-b694737e4c86"
}
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
    subscription_id = "e21901bf-488a-4ded-b169-b694737e4c86"
 }

resource "azurerm_resource_group" "Test_rg" {
    name  = "test_resource_group"
    location = "eastus2"
        
}
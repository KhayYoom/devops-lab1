# Configure the Azure provider
terraform {                   // The "terraform" block is where you specify the required providers and Terraform version. You can also set backend configuration 
                                //    here if you're using a remote backend (like Azure Storage for state files).
  required_providers {         // This block specifies which providers your Terraform configuration depends on. In this case, it's the Azure Resource Manager (azurerm) provider.
    azurerm = {           // The "azurerm" provider is used to manage Azure resources. You specify the source and version constraints for the provider here.
      source  = "hashicorp/azurerm"   // The "source" attribute tells Terraform where to find the provider. "hashicorp/azurerm" means it's maintained by HashiCorp and is for Azure Resource Manager.
      version = "~> 3.0.2"       // The "version" attribute specifies which version of the provider to use. "~> 3.0.2" means it will use any version in the 3.x series that is at least 3.0.2 but less than 4.0.0.
    }
  }

  required_version = ">= 1.1.0"    // This specifies the minimum version of Terraform required to use this configuration. In this case, it requires Terraform version 1.1.0 or higher.
}

provider "azurerm" {            // This block configures the Azure provider with specific settings. The "features" block is required but can be left empty if you don't need to configure any specific features. The "subscription_id" is where you would put your Azure subscription ID to authenticate with Azure.
  features {}
  subscription_id = "e21901bf-488a-4ded-b169-b694737e4c86"     // Your Azure subscription ID
}
resource "azurerm_resource_group" "rg" {  //  This block defines an Azure Resource Group resource. The "name" and "location" attributes are set using variables defined in the "variables.tf" file. The resource group is a container that holds related resources for an Azure solution.
  name     = var.resource_group_name      // The name of the resource group, which is defined as a variable in the "variables.tf" file. This allows you to easily change the name without modifying the code.
  location = var.location             // The Azure region where the resource group will be created, also defined as a variable in the "variables.tf" file.
}

resource "azurerm_storage_account" "storage" {
  name                     = var.storage_account_name
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = {
    environment = "dev"
  }
}

resource "azurerm_storage_container" "container" {
  name                  = var.container_name
  storage_account_name  = azurerm_storage_account.storage.name
  container_access_type = "private"
}



resource "azurerm_virtual_network" "vnet" {
  name                = var.virtual_network_name
  address_space       = ["10.0.0.0/16"]
  location             = var.location
  resource_group_name  = var.resource_group_name
}

resource "azurerm_subnet" "subnet" {
  name                 = var.subnet_name
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_public_ip" "pip" {
  name               = "myTFPublicIP987"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"

}

resource "azurerm_network_interface" "nic" {
  name                = "myTFNIC987"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "myTFIPConfig987"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.pip.id
  }
}

resource "azurerm_linux_virtual_machine" "vm" {
  name                = "myTFVM987"
  resource_group_name = var.resource_group_name
  location            = var.location
  size                = "Standard_DS1_v2"
  admin_username      = "azureuser"

  network_interface_ids = [
    azurerm_network_interface.nic.id,
  ]

  admin_ssh_key {
    username   = "azureuser"
    public_key = file("C:/Users/KhayumMohammed/.ssh/id_rsa.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
}

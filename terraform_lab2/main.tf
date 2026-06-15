# main.tf — Lab 4: A Linux VM and everything it needs to exist.
#
# Dependency chain (Terraform figures this order out automatically
# from the references between resources):
#
#   Resource Group
#        └── Virtual Network
#               └── Subnet ─────────────┐
#   Public IP ───────────────┐          │
#   Network Security Group    │          │
#        └── NSG <-> Subnet   │          │
#                             ▼          ▼
#                        Network Interface (NIC)
#                                 └── Linux Virtual Machine

terraform {
  required_version = ">= 1.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }
}

provider "azurerm" {
  features {}
}

# 1) Resource Group — the container for everything below.
resource "azurerm_resource_group" "lab" {
  name     = var.resource_group_name
  location = var.location
  tags     = var.tags
}

# 2) Virtual Network — your private network in Azure (a big IP range).
resource "azurerm_virtual_network" "lab" {
  name                = "vnet-lab4"
  address_space       = ["10.0.0.0/16"] # 65,536 addresses
  location            = azurerm_resource_group.lab.location
  resource_group_name = azurerm_resource_group.lab.name
  tags                = var.tags
}

# 3) Subnet — a slice of the VNet where the VM's NIC will live.
resource "azurerm_subnet" "lab" {
  name                 = "subnet-lab4"
  resource_group_name  = azurerm_resource_group.lab.name
  virtual_network_name = azurerm_virtual_network.lab.name
  address_prefixes     = ["10.0.1.0/24"] # 256 addresses inside the VNet
}

# 4) Public IP — so you can reach the VM from the internet (to SSH in).
resource "azurerm_public_ip" "lab" {
  name                = "pip-lab4"
  location            = azurerm_resource_group.lab.location
  resource_group_name = azurerm_resource_group.lab.name
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = var.tags
}

# 5) Network Security Group — a firewall. Here we allow inbound SSH (port 22).
resource "azurerm_network_security_group" "lab" {
  name                = "nsg-lab4"
  location            = azurerm_resource_group.lab.location
  resource_group_name = azurerm_resource_group.lab.name
  tags                = var.tags

  security_rule {
    name                       = "Allow-SSH"
    priority                   = 1001 # lower number = evaluated first
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*" # NOTE: "*" = open to whole internet.
    destination_address_prefix = "*" #       For real use, restrict to your IP.
  }
}

# 6a) Network Interface — the VM's virtual network card. Joins the subnet
#     and attaches the public IP.
resource "azurerm_network_interface" "lab" {
  name                = "nic-lab4"
  location            = azurerm_resource_group.lab.location
  resource_group_name = azurerm_resource_group.lab.name
  tags                = var.tags

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.lab.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.lab.id
  }
}

# 6b) Associate the NSG (firewall) with the NIC so its rules apply.
resource "azurerm_network_interface_security_group_association" "lab" {
  network_interface_id      = azurerm_network_interface.lab.id
  network_security_group_id = azurerm_network_security_group.lab.id
}

# 7) The Linux Virtual Machine itself.
resource "azurerm_linux_virtual_machine" "lab" {
  name                  = "vm-lab4"
  location              = azurerm_resource_group.lab.location
  resource_group_name   = azurerm_resource_group.lab.name
  size                  = var.vm_size
  admin_username        = var.admin_username
  network_interface_ids = [azurerm_network_interface.lab.id]

  # SSH key auth (no password). We read the .pub file we generated earlier.
  admin_ssh_key {
    username   = var.admin_username
    public_key = file("${path.module}/ssh/id_rsa.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  # Which OS image to install: Ubuntu Server 22.04 LTS.
  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }

  tags = var.tags
}
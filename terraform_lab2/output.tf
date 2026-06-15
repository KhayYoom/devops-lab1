# outputs.tf — useful values printed after apply.

output "vm_public_ip" {
  description = "Public IP address of the VM"
  value       = azurerm_public_ip.lab.ip_address
}

output "admin_username" {
  description = "The admin username for SSH"
  value       = var.admin_username
}

# A ready-to-paste SSH command. Uses the private key we generated.
output "ssh_command" {
  description = "Copy-paste this to connect to your VM"
  value       = "ssh -i ssh/id_rsa ${var.admin_username}@${azurerm_public_ip.lab.ip_address}"
}
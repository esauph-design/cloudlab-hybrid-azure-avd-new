output "management_vm_id" {
  value = azurerm_windows_virtual_machine.management.id
}

output "management_vm_name" {
  value = azurerm_windows_virtual_machine.management.name
}

output "management_vm_private_ip" {
  value = azurerm_network_interface.management.private_ip_address
}

output "management_nic_id" {
  value = azurerm_network_interface.management.id
}
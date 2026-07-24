output "management_nsg_id" {
  value = azurerm_network_security_group.management.id
}

output "servers_nsg_id" {
  value = azurerm_network_security_group.servers.id
}

output "avd_nsg_id" {
  value = azurerm_network_security_group.avd.id
}
output "management_nsg_name" {
  value = azurerm_network_security_group.management.name
}

output "servers_nsg_name" {
  value = azurerm_network_security_group.servers.name
}

output "avd_nsg_name" {
  value = azurerm_network_security_group.avd.name
}
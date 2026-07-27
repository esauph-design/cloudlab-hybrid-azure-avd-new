output "vnet_name" {
  value = azurerm_virtual_network.cloudlab.name
}

output "vnet_id" {
  value = azurerm_virtual_network.cloudlab.id
}

output "management_subnet_id" {
  value = azurerm_subnet.management.id
}

output "servers_subnet_id" {
  value = azurerm_subnet.servers.id
}

output "avd_subnet_id" {
  value = azurerm_subnet.avd.id
}
output "private_endpoints_subnet_id" {
  value = azurerm_subnet.snet-private-endpoints.id
}
output "resource_group_name" {
  value = azurerm_resource_group.network.name
}
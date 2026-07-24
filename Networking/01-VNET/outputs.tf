output "vnet_name" {
  value = azurerm_virtual_network.cloudlab.name
}

<<<<<<< HEAD
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

output "resource_group_name" {
  value = azurerm_resource_group.network.name
=======
output "management_subnet" {
  value = azurerm_subnet.management.name
}

output "servers_subnet" {
  value = azurerm_subnet.servers.name
}

output "avd_subnet" {
  value = azurerm_subnet.avd.name
>>>>>>> be1523943333c930ad849e8f4c451c1dd6fb626d
}
output "private_endpoint_id" {
  value = azurerm_private_endpoint.storage_file.id
}

output "private_endpoint_name" {
  value = azurerm_private_endpoint.storage_file.name
}

output "private_endpoint_ip" {
  value = azurerm_private_endpoint.storage_file.private_service_connection[0].private_ip_address
}

output "private_dns_zone_id" {
  value = azurerm_private_dns_zone.storage_file.id
}

output "private_dns_zone_name" {
  value = azurerm_private_dns_zone.storage_file.name
}
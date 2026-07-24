output "storage_account_id" {
  value = azurerm_storage_account.storage_account.id
}

output "storage_account_name" {
  value = azurerm_storage_account.storage_account.name
}
output "primary_blob_endpoint" {
  value = azurerm_storage_account.storage_account.primary_blob_endpoint
}
output "blob_container_name" {
  value = azurerm_storage_container.blob_container.name
}
output "blob_container_id" {
  value = azurerm_storage_container.blob_container.id
}
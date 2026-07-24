resource "azurerm_resource_group" "resource_group_name" {
  name     = var.resource_group_name
  location = var.location
  tags     = var.tags
}

resource "azurerm_storage_account" "storage_account" {
  name                              = var.storage_account_name
  resource_group_name               = var.resource_group_name
  location                          = var.location
  account_tier                      = var.account_tier
  account_replication_type          = var.account_replication_type
  account_kind                      = var.account_kind
  public_network_access_enabled     = var.public_network_access_enabled
  allow_nested_items_to_be_public   = var.allow_nested_items_to_be_public
  shared_access_key_enabled         = var.shared_access_key_enabled
  min_tls_version                   = var.min_tls_version
  infrastructure_encryption_enabled = var.infrastructure_encryption_enabled
  https_traffic_only_enabled        = var.https_traffic_only_enabled
  tags                              = var.tags
}
resource "azurerm_storage_container" "blob_container" {
  name                  = var.container_name
  storage_account_id    = azurerm_storage_account.storage_account.id
  container_access_type = var.container_access_type

}

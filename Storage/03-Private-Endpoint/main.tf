resource "azurerm_private_dns_zone" "storage_file" {
  name                = "privatelink.file.core.windows.net"
  resource_group_name = "rg-storage-dev"

  tags = var.tags
}
resource "azurerm_private_dns_zone_virtual_network_link" "storage_file" {
  name                  = "link-vnet-cloudlab-storage-file"
  resource_group_name   = "rg-storage-dev"
  private_dns_zone_name = azurerm_private_dns_zone.storage_file.name
  virtual_network_id    = data.terraform_remote_state.networking.outputs.vnet_id

  registration_enabled = false

  tags = var.tags
}
resource "azurerm_private_endpoint" "storage_file" {
  name                = "pe-stcloudlabdev01-file"
  location            = var.location
  resource_group_name = "rg-storage-dev"

  subnet_id = data.terraform_remote_state.networking.outputs.private_endpoints_subnet_id

  private_service_connection {
    name                           = "psc-stcloudlabdev01-file"
    private_connection_resource_id = data.terraform_remote_state.storage.outputs.storage_account_id
    subresource_names              = ["file"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name = "pdzg-storage-file"

    private_dns_zone_ids = [
      azurerm_private_dns_zone.storage_file.id
    ]
  }

  tags = var.tags
}
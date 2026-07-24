resource "azurerm_network_security_group" "management" {

  name                = "nsg-management-dev"
  location            = var.location
  resource_group_name = data.terraform_remote_state.networking.outputs.resource_group_name
  tags                = var.tags

}
resource "azurerm_network_security_group" "servers" {

  name                = "nsg-servers-dev"
  location            = var.location
  resource_group_name = data.terraform_remote_state.networking.outputs.resource_group_name
  tags                = var.tags

}
resource "azurerm_network_security_group" "avd" {

  name                = "nsg-avd-dev"
  location            = var.location
  resource_group_name = data.terraform_remote_state.networking.outputs.resource_group_name
  tags                = var.tags

}
resource "azurerm_network_security_rule" "management_rdp" {

  name = "Allow-RDP"

  priority  = 100
  direction = "Inbound"
  access    = "Allow"
  protocol  = "Tcp"

  source_port_range      = "*"
  destination_port_range = "3389"

  source_address_prefix      = "*"
  destination_address_prefix = "*"

  resource_group_name         = data.terraform_remote_state.networking.outputs.resource_group_name
  network_security_group_name = azurerm_network_security_group.management.name


}
resource "azurerm_network_security_rule" "management_ssh" {

  name = "Allow-SSH"

  priority  = 110
  direction = "Inbound"
  access    = "Allow"
  protocol  = "Tcp"

  source_port_range      = "*"
  destination_port_range = "22"

  source_address_prefix      = "*"
  destination_address_prefix = "*"

  resource_group_name         = data.terraform_remote_state.networking.outputs.resource_group_name
  network_security_group_name = azurerm_network_security_group.management.name

}
resource "azurerm_network_security_rule" "management_https" {

  name = "Allow-HTTPS"

  priority  = 120
  direction = "Inbound"
  access    = "Allow"
  protocol  = "Tcp"

  source_port_range      = "*"
  destination_port_range = "443"

  source_address_prefix      = "*"
  destination_address_prefix = "*"

  resource_group_name         = data.terraform_remote_state.networking.outputs.resource_group_name
  network_security_group_name = azurerm_network_security_group.management.name

}
resource "azurerm_network_security_rule" "servers_https" {

  name = "Allow-HTTPS"

  priority  = 100
  direction = "Inbound"
  access    = "Allow"
  protocol  = "Tcp"

  source_port_range      = "*"
  destination_port_range = "443"

  source_address_prefix      = "*"
  destination_address_prefix = "*"

  resource_group_name         = data.terraform_remote_state.networking.outputs.resource_group_name
  network_security_group_name = azurerm_network_security_group.servers.name

}
resource "azurerm_network_security_rule" "avd_https" {

  name = "Allow-HTTPS"

  priority  = 100
  direction = "Inbound"
  access    = "Allow"
  protocol  = "Tcp"

  source_port_range      = "*"
  destination_port_range = "443"

  source_address_prefix      = "*"
  destination_address_prefix = "*"

  resource_group_name         = data.terraform_remote_state.networking.outputs.resource_group_name
  network_security_group_name = azurerm_network_security_group.avd.name

}
resource "azurerm_subnet_network_security_group_association" "management" {

  subnet_id = data.terraform_remote_state.networking.outputs.management_subnet_id

  network_security_group_id = azurerm_network_security_group.management.id


}
resource "azurerm_subnet_network_security_group_association" "servers" {

  subnet_id = data.terraform_remote_state.networking.outputs.servers_subnet_id

  network_security_group_id = azurerm_network_security_group.servers.id

}
resource "azurerm_subnet_network_security_group_association" "avd" {

  subnet_id = data.terraform_remote_state.networking.outputs.avd_subnet_id

  network_security_group_id = azurerm_network_security_group.avd.id

}
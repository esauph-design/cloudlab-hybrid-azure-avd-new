resource "azurerm_resource_group" "network" {

  name     = var.resource_group_name
  location = var.location
<<<<<<< HEAD
  tags     = var.tags
=======
>>>>>>> be1523943333c930ad849e8f4c451c1dd6fb626d

}
resource "azurerm_virtual_network" "cloudlab" {

  name                = "vnet-cloudlab"
  location            = var.location
  resource_group_name = azurerm_resource_group.network.name
<<<<<<< HEAD
  tags                = var.tags
=======
>>>>>>> be1523943333c930ad849e8f4c451c1dd6fb626d

  address_space = [
    "10.10.0.0/16"
  ]

}
resource "azurerm_subnet" "management" {

  name                 = "snet-management"
  resource_group_name  = azurerm_resource_group.network.name
  virtual_network_name = azurerm_virtual_network.cloudlab.name

<<<<<<< HEAD

=======
>>>>>>> be1523943333c930ad849e8f4c451c1dd6fb626d
  address_prefixes = [
    "10.10.1.0/24"
  ]

}
resource "azurerm_subnet" "servers" {

  name                 = "snet-servers"
  resource_group_name  = azurerm_resource_group.network.name
  virtual_network_name = azurerm_virtual_network.cloudlab.name

<<<<<<< HEAD

=======
>>>>>>> be1523943333c930ad849e8f4c451c1dd6fb626d
  address_prefixes = [
    "10.10.2.0/24"
  ]

}
resource "azurerm_subnet" "avd" {

  name                 = "snet-avd"
  resource_group_name  = azurerm_resource_group.network.name
  virtual_network_name = azurerm_virtual_network.cloudlab.name

  address_prefixes = [
    "10.10.3.0/24"
  ]

}
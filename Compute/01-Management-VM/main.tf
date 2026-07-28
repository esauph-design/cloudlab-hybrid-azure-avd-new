# ---------------------------------------------------------
# Resource Group
# ---------------------------------------------------------

resource "azurerm_resource_group" "compute" {
  name     = "rg-compute-dev"
  location = var.location

  tags = var.tags
}


# ---------------------------------------------------------
# Network Interface
# ---------------------------------------------------------

resource "azurerm_network_interface" "management" {
  name                = "nic-az-mgmt01"
  location            = var.location
  resource_group_name = azurerm_resource_group.compute.name

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = data.terraform_remote_state.networking.outputs.management_subnet_id
    private_ip_address_allocation = "Dynamic"
  }

  tags = var.tags
}


# ---------------------------------------------------------
# Management VM
# ---------------------------------------------------------

resource "azurerm_windows_virtual_machine" "management" {
  name                = "AZ-MGMT01"
  computer_name       = "AZ-MGMT01"
  resource_group_name = azurerm_resource_group.compute.name
  location            = var.location
  size                = "Standard_D2s_v4"

  admin_username = var.admin_username
  admin_password = var.admin_password

  network_interface_ids = [
    azurerm_network_interface.management.id
  ]

  os_disk {
    name                 = "osdisk-az-mgmt01"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2022-datacenter-azure-edition"
    version   = "latest"
  }

  tags = var.tags
}
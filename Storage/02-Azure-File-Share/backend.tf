terraform {
  backend "azurerm" {
    resource_group_name  = "rg-terraform-dev"
    storage_account_name = "stterraformesau01"
    container_name       = "tfstate"
    key                  = "02-Azure-File-Share.tfstate"
  }
}
data "terraform_remote_state" "networking" {
  backend = "azurerm"

  config = {
    resource_group_name  = "rg-terraform-dev"
    storage_account_name = "stterraformesau01"
    container_name       = "tfstate"
    key                  = "01-vnet.tfstate"
  }
}
# Create Resource Group

az group create `
--name rg-terraform-dev `
--location eastus


# Create Storage Account

az storage account create `
--resource-group rg-terraform-dev `
--name stterraformesau01 `
--sku Standard_LRS `
--location eastus


# Create Container

az storage container create `
--name tfstate `
--account-name stterraformesau01 `
--auth-mode login
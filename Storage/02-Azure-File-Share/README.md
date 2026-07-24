Purpose
-------

Deploys:

- Management NSG
- Servers NSG
- AVD NSG

Creates:

- Security Rules
- NSG Associations

Consumes:

- VNET Remote State

Outputs:

- NSG IDs
- NSG Names

Terraform State:

- 02-nsg.tfstate

Dependencies:

- 01-VNET
# 01 - Azure Management VM

## Overview

This Terraform module deploys a Windows Server management VM into the existing CloudLab Azure network.

The VM provides an Azure-side administrative system that will later be used for hybrid connectivity validation, DNS testing, Azure Files connectivity testing, domain integration, and Azure Virtual Desktop administration.

The VM is deployed without a public IP address and resides in the dedicated management subnet.

---

## Architecture

```text
                    vnet-cloudlab
                         |
                  snet-management
                    10.10.1.0/24
                         |
                         v
                  nic-az-mgmt01
                         |
                    10.10.1.4
                         |
                         v
                     AZ-MGMT01
                 Windows Server 2022
```

The VM currently has no public IP address.

Future administrative connectivity will be provided through the hybrid network connection between the on-premises CloudLab environment and Azure.

---

## Purpose

`AZ-MGMT01` provides an Azure-based management server for the CloudLab environment.

It will be used for tasks including:

- Azure network connectivity testing
- Private DNS validation
- Azure Private Endpoint testing
- Azure Files SMB connectivity testing
- Hybrid connectivity validation
- Active Directory domain integration
- PowerShell administration
- Azure Virtual Desktop administration
- Infrastructure troubleshooting

The VM is not a Domain Controller.

Active Directory Domain Services remain hosted in the on-premises CloudLab environment.

---

## Resources Deployed

| Resource | Name |
|---|---|
| Resource Group | rg-compute-dev |
| Network Interface | nic-az-mgmt01 |
| Virtual Machine | AZ-MGMT01 |
| VM Size | Standard_D2s_v4 |
| Operating System | Windows Server 2022 Datacenter Azure Edition |
| OS Disk | osdisk-az-mgmt01 |
| Disk Type | Standard_LRS |
| Subnet | snet-management |
| Private IP | 10.10.1.4 |
| Public IP | None |

---

## Network Design

The VM is deployed into:

```text
vnet-cloudlab
└── snet-management
    └── AZ-MGMT01
        └── 10.10.1.4
```

The subnet is retrieved from the Networking Terraform deployment using remote state.

```hcl
subnet_id = data.terraform_remote_state.networking.outputs.management_subnet_id
```

This prevents Azure resource IDs from being hard-coded into the Compute module.

---

## Security Design

The VM does not have a public IP address.

The intended architecture is:

```text
Internet
   |
   X
   |
AZ-MGMT01
```

Direct RDP access from the Internet is therefore not part of the design.

Future access will use the hybrid network:

```text
On-Premises CloudLab
        |
        | Site-to-Site VPN
        |
        v
    Azure VNet
        |
        v
 snet-management
        |
        v
    AZ-MGMT01
     10.10.1.4
```

This allows administrative traffic to remain on private network paths.

---

## VM Configuration

The VM uses:

```text
VM Size: Standard_D2s_v4
vCPU:    2
Memory:  8 GiB
```

The original lab design considered B-series VM sizes to reduce compute cost.

However, available B-series options encountered regional capacity or subscription quota restrictions in East US.

`Standard_D2s_v4` was therefore selected and successfully deployed.

---

## Operating System

The VM uses:

```hcl
source_image_reference {
  publisher = "MicrosoftWindowsServer"
  offer     = "WindowsServer"
  sku       = "2022-datacenter-azure-edition"
  version   = "latest"
}
```

This deploys Windows Server 2022 Datacenter Azure Edition.

---

## Terraform Dependencies

This module consumes remote state from:

```text
Networking
└── 01-VNET
```

The Networking module provides:

```text
management_subnet_id
```

Dependency model:

```text
Networking
01-VNET
   |
   | management_subnet_id
   v
Compute
01-Management-VM
```

The Management VM module does not need direct Terraform dependencies on the Storage modules.

Storage connectivity will occur through the Azure network.

---

## Terraform Backend

The module uses the shared Azure Terraform backend.

State file:

```text
01-management-vm.tfstate
```

Backend architecture:

```text
stterraformesau01
└── tfstate
    ├── 01-vnet.tfstate
    ├── 01-storage-account.tfstate
    ├── 02-azure-file-share.tfstate
    ├── 03-private-endpoint.tfstate
    └── 01-management-vm.tfstate
```

Each infrastructure deployment maintains an independent Terraform state while allowing required outputs to be consumed through remote state.

---

## Terraform Files

```text
Compute
└── 01-Management-VM
    |
    ├── backend.tf
    ├── main.tf
    ├── outputs.tf
    ├── providers.tf
    ├── remote-state.tf
    ├── variables.tf
    ├── terraform.tfvars
    └── README.md
```

`terraform.tfvars` contains local configuration and sensitive values and should not be committed to Git.

---

## Credentials

The local administrator credentials are supplied through Terraform variables.

Example:

```hcl
admin_username = "localadmin"
admin_password = "<password>"
```

The password variable is marked as sensitive.

Sensitive Terraform variables can still exist inside Terraform state. Access to the remote Terraform backend must therefore be appropriately secured.

Do not commit credentials or `terraform.tfvars` to the repository.

---

## Outputs

The module exports:

| Output | Description |
|---|---|
| management_vm_id | Azure Resource ID of AZ-MGMT01 |
| management_vm_name | VM name |
| management_vm_private_ip | Private IPv4 address |
| management_nic_id | Azure Resource ID of the NIC |

Current deployment:

```text
management_vm_name       = "AZ-MGMT01"
management_vm_private_ip = "10.10.1.4"
```

---

## Deployment

Initialize Terraform:

```powershell
terraform init
```

Validate:

```powershell
terraform validate
```

Review the execution plan:

```powershell
terraform plan
```

Deploy:

```powershell
terraform apply
```

Review outputs:

```powershell
terraform output
```

---

## VM Cost Management

The VM should be deallocated when it is not required for lab work.

```powershell
az vm deallocate `
  --resource-group rg-compute-dev `
  --name AZ-MGMT01
```

VM status can be checked with:

```powershell
az vm get-instance-view `
  --resource-group rg-compute-dev `
  --name AZ-MGMT01 `
  --query "instanceView.statuses[?starts_with(code, 'PowerState/')].displayStatus" `
  -o tsv
```

When deallocated, VM compute billing stops. Associated resources such as managed disks continue to incur applicable storage charges.

To start the VM again:

```powershell
az vm start `
  --resource-group rg-compute-dev `
  --name AZ-MGMT01
```

---

## Future Validation

Once hybrid connectivity is established, connectivity from the on-premises management environment can be tested with:

```powershell
Test-NetConnection 10.10.1.4 -Port 3389
```

The VM can then be used to test Azure Files Private Link DNS:

```powershell
nslookup stcloudlabdev01.file.core.windows.net
```

The Storage Account File endpoint should resolve through Private Link to:

```text
10.10.4.4
```

SMB connectivity can then be validated using:

```powershell
Test-NetConnection stcloudlabdev01.file.core.windows.net -Port 445
```

Expected:

```text
TcpTestSucceeded : True
```

---

## Current Architecture

```text
                         Azure
                           |
                    vnet-cloudlab
                           |
       +-------------------+-------------------+
       |                   |                   |
snet-management      snet-servers          snet-avd
       |
       |
  AZ-MGMT01
   10.10.1.4


snet-private-endpoints
       |
       v
pe-stcloudlabdev01-file
       |
    10.10.4.4
       |
       v
stcloudlabdev01
       |
       v
    fslogix
```

---

## Next Phase

The next phase of the CloudLab project will introduce hybrid network connectivity between the on-premises VMware lab and Azure.

```text
On-Premises CloudLab
        |
        | Hybrid Connectivity
        |
        v
    vnet-cloudlab
        |
        +--> AZ-MGMT01
        |
        +--> Azure Private Endpoints
        |
        +--> Future AVD Session Hosts
```

This will enable private communication between on-premises Active Directory infrastructure and Azure workloads.

---

## Technologies Used

- Microsoft Azure
- Terraform
- Azure Virtual Machines
- Azure Virtual Network
- Windows Server 2022
- Terraform Remote State
- PowerShell
- Azure CLI
- Git

---

## Author

**Esau Picado**

CloudLab Hybrid Azure AVD Lab

Hybrid Azure infrastructure built with Terraform.
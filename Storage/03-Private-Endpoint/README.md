# 03 - Azure Files Private Endpoint

## Overview

This Terraform module deploys private network connectivity for the Azure Files service used by the CloudLab Hybrid Azure Virtual Desktop (AVD) environment.

The module creates an Azure Private Endpoint for the File service of the existing Storage Account, along with a Private DNS Zone and Virtual Network link.

The Private Endpoint allows Azure resources to access Azure Files through a private IP address inside `vnet-cloudlab` instead of relying on the public Storage Account endpoint.

---

## Architecture

```text
                        vnet-cloudlab
                             |
        +--------------------+--------------------+
        |                    |                    |
 snet-management       snet-servers          snet-avd
                                                  

                    snet-private-endpoints
                             |
                          10.10.4.4
                             |
                  pe-stcloudlabdev01-file
                             |
                       Private Link
                             |
                    stcloudlabdev01
                             |
                       File Service
                             |
                          fslogix
```

DNS integration:

```text
stcloudlabdev01.file.core.windows.net
                    |
                    v
stcloudlabdev01.privatelink.file.core.windows.net
                    |
                    v
                 10.10.4.4
```

---

## Purpose

This module provides private connectivity between `vnet-cloudlab` and the Azure Files service hosted by:

```text
stcloudlabdev01
```

The Azure File Share:

```text
fslogix
```

will later provide FSLogix profile storage for Azure Virtual Desktop session hosts.

---

## Resources Deployed

| Resource | Name |
|---|---|
| Private Endpoint | pe-stcloudlabdev01-file |
| Private DNS Zone | privatelink.file.core.windows.net |
| VNet DNS Link | link-vnet-cloudlab-storage-file |
| Private Endpoint IP | 10.10.4.4 |

The Private Endpoint is deployed into:

```text
snet-private-endpoints
```

This dedicated subnet separates Private Endpoint network interfaces from management, server, and AVD workloads.

---

## Private Endpoint

The Private Endpoint connects specifically to the Azure Storage **File** service.

Terraform configuration:

```hcl
subresource_names = ["file"]
```

Azure Storage provides multiple services, including:

```text
blob
file
queue
table
dfs
web
```

This Private Endpoint provides private connectivity only to the File service.

Other Storage services can use separate Private Endpoints when required.

---

## Private DNS

The module creates the Azure Private DNS Zone:

```text
privatelink.file.core.windows.net
```

The zone is linked to:

```text
vnet-cloudlab
```

The Private Endpoint DNS Zone Group integrates the endpoint with the Private DNS Zone.

This allows resources using the Azure private DNS architecture to resolve the Storage Account File service to its Private Endpoint IP.

Current Private Endpoint IP:

```text
10.10.4.4
```

---

## Terraform Dependencies

This module consumes remote state from two existing Terraform deployments.

### Networking

```text
Networking
└── 01-VNET
```

Used to retrieve:

- Virtual Network ID
- Private Endpoint subnet ID

For example:

```hcl
data.terraform_remote_state.networking.outputs.vnet_id

data.terraform_remote_state.networking.outputs.private_endpoints_subnet_id
```

### Storage

```text
Storage
└── 01-Storage-Account
```

Used to retrieve:

- Storage Account ID

For example:

```hcl
data.terraform_remote_state.storage.outputs.storage_account_id
```

This avoids hard-coded Azure resource IDs between Terraform deployments.

---

## Terraform Dependency Model

```text
Networking
01-VNET
   |
   +--------------------+
                        |
                        v
                 03-Private-Endpoint
                        ^
                        |
                        |
Storage                 |
01-Storage-Account -----+
   |
   v
02-Azure-File-Share
```

The Private Endpoint targets the Storage Account File service rather than an individual Azure File Share.

---

## Terraform Files

```text
03-Private-Endpoint
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

---

## Terraform Backend

This module uses the shared Azure remote Terraform backend.

State file:

```text
03-private-endpoint.tfstate
```

Remote state provides:

- Centralized state storage
- State locking
- Independent module lifecycle
- Cross-module output consumption

---

## Outputs

The module exports:

| Output | Description |
|---|---|
| private_endpoint_id | Azure Resource ID of the Private Endpoint |
| private_endpoint_name | Private Endpoint name |
| private_endpoint_ip | Private IP assigned to the endpoint |
| private_dns_zone_id | Azure Resource ID of the Private DNS Zone |
| private_dns_zone_name | Private DNS Zone name |

Example:

```text
private_dns_zone_name = "privatelink.file.core.windows.net"

private_endpoint_name = "pe-stcloudlabdev01-file"

private_endpoint_ip = "10.10.4.4"
```

---

## Validation

Initialize Terraform:

```powershell
terraform init
```

Validate the configuration:

```powershell
terraform validate
```

Review the deployment:

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

From a Windows VM with appropriate connectivity and DNS resolution, DNS can later be tested using:

```powershell
nslookup stcloudlabdev01.file.core.windows.net
```

The Storage Account File service should ultimately resolve through Private Link to:

```text
10.10.4.4
```

SMB connectivity can be tested with:

```powershell
Test-NetConnection stcloudlabdev01.file.core.windows.net -Port 445
```

---

## Security Design

The Storage Account has public network access disabled.

Azure Files connectivity is therefore designed around:

```text
Azure VNet
    |
Private Endpoint
    |
Private Link
    |
Azure Files
```

This prevents the AVD architecture from depending on public network access to the Storage Account.

Additional security and access controls will be introduced as the AVD and FSLogix infrastructure is built.

---

## Hybrid DNS Considerations

The Private DNS Zone is currently linked to `vnet-cloudlab`.

On-premises Active Directory DNS servers do not automatically gain access to Azure Private DNS Zones.

Future hybrid connectivity will require a DNS architecture capable of resolving Azure private endpoint records from on-premises networks.

The future design may include:

```text
On-Premises AD DNS
        |
Conditional Forwarding
        |
        v
Azure DNS Private Resolver
        |
        v
Azure Private DNS
        |
privatelink.file.core.windows.net
        |
        v
10.10.4.4
```

Hybrid network connectivity between the on-premises environment and Azure will also be required to reach Private Endpoint addresses.

---

## Project Roadmap

```text
Backend
└── Azure Terraform Backend             DONE

Networking
├── 01-VNET                             DONE
└── 02-NSG                              DONE

Storage
├── 01-Storage-Account                  DONE
├── 02-Azure-File-Share                 DONE
└── 03-Private-Endpoint                 DONE

Compute
└── Azure Management Infrastructure     NEXT

Identity
└── Hybrid Identity

Azure Virtual Desktop
├── Host Pool
├── Workspace
├── Application Group
├── Session Hosts
└── FSLogix
```

---

## Technologies Used

- Microsoft Azure
- Terraform
- Azure Private Link
- Azure Private Endpoints
- Azure Private DNS
- Azure Files
- Azure Virtual Network
- Terraform Remote State
- PowerShell
- Azure CLI
- Git

---

## Author

**Esau Picado**

CloudLab Hybrid Azure AVD Lab

Hybrid Azure infrastructure built with Terraform.
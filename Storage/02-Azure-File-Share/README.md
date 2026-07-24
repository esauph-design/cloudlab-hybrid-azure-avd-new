# 02 - Azure File Share

## Overview

This module deploys an Azure File Share that will be used to store FSLogix profile containers for Azure Virtual Desktop (AVD) session hosts. It follows Terraform modular design principles and consumes outputs from previously deployed Terraform modules using Terraform Remote State.

The Azure File Share is intentionally deployed as a separate Terraform module from the Storage Account to provide better lifecycle management, modularity, and reusability.

---

## Architecture

```
CloudLab Hybrid Azure AVD Lab

                    Azure Subscription
                             |
                     rg-storage-dev
                             |
                   stcloudlabdev01
                             |
                      Azure Files
                             |
                        fslogix
                             |
                             |
                     Future Components
                             |
                -----------------------------
                |                           |
            FSLogix                     AVD Session Hosts
           Profiles                          (Azure)
                |                                 |
                -----------------------------------
                                 |
                        Azure Virtual Desktop
```

---

## Purpose

This module creates:

- Azure File Share
  - fslogix

The file share will later be used for:

- FSLogix Profile Containers
- Azure Virtual Desktop user profiles
- Hybrid Azure Virtual Desktop deployments
- Domain-joined Session Hosts

---

## Module Dependencies

This module consumes outputs from:

```
Storage
│
└── 01-Storage-Account
```

Required outputs include:

- storage_account_name
- storage_account_id

Terraform Remote State is used to automatically retrieve these values.

---

## Resources Deployed

| Resource Type | Name |
|---------------|------|
| Azure File Share | fslogix |

---

## Azure File Share Configuration

| Setting | Value |
|--------|--------|
| Name | fslogix |
| Protocol | SMB |
| Quota | 100 GB |
| Storage Account | stcloudlabdev01 |
| Access | Private |

---

## Terraform Files

```
02-Azure-File-Share
│
├── backend.tf
├── main.tf
├── outputs.tf
├── providers.tf
├── remote-state.tf
├── variables.tf
├── terraform.tfvars
├── README.md
└── .gitignore
```

---

## Terraform Backend

This module uses:

```
Azure Remote Backend
```

Terraform State File:

```
02-azure-file-share.tfstate
```

Benefits include:

- Remote state storage
- State locking
- Collaboration support
- Dependency management
- Infrastructure consistency

---

## Terraform Dependency Chain

```
01-VNET
    |
    v

02-NSG
    |
    v

01-Storage-Account
    |
    v

02-Azure-File-Share
```

Future dependencies:

```
03-Private-Endpoint
        |
        v

01-Management-VM
        |
        v

Hybrid Identity
        |
        v

Azure Virtual Desktop
        |
        v

FSLogix Configuration
```

---

## Outputs

This module exports the following outputs:

| Output | Description |
|-------|-------|
| file_share_name | Azure File Share name |
| file_share_id | Azure File Share Resource ID |
| file_share_url | Azure File Share URL |

Example output:

```
file_share_name = "fslogix"

file_share_url =
https://stcloudlabdev01.file.core.windows.net/fslogix
```

---

## Deployment

Initialize Terraform:

```bash
terraform init
```

Validate the configuration:

```bash
terraform validate
```

Review the deployment plan:

```bash
terraform plan
```

Deploy the resources:

```bash
terraform apply
```

Verify the outputs:

```bash
terraform output
```

---

## Security Considerations

Current security controls include:

- HTTPS traffic only (inherited from the Storage Account)
- Azure Storage encryption
- Terraform remote state locking
- SMB protocol support
- Private Azure File Share

Future security enhancements include:

- Private Endpoints
- Private DNS Zones
- RBAC
- Hybrid DNS integration
- Azure Virtual Desktop access controls

---

## Future Enhancements

Upcoming Storage modules include:

```
Storage
│
├── 01-Storage-Account
├── 02-Azure-File-Share
└── 03-Private-Endpoint
```

The Azure File Share will later be used for:

- FSLogix Profile Containers
- Azure Virtual Desktop Session Hosts
- Hybrid Azure environments
- Domain-joined user profiles

---

## Technologies Used

- Microsoft Azure
- Terraform
- Azure Files
- Azure Virtual Desktop
- Terraform Remote State
- Azure Storage Accounts
- Git
- Azure CLI
- Visual Studio Code
- PowerShell 7

---

## Author

**Esau Picado**

CloudLab Hybrid Azure AVD Lab

Enterprise-grade Hybrid Azure Infrastructure built with Terraform.
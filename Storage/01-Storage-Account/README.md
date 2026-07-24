# 01 - Storage Account

## Overview

This module deploys an Azure Storage Account and a private Blob Storage container using Terraform. It is designed as part of the CloudLab Hybrid Azure Virtual Desktop (AVD) Lab and follows Infrastructure as Code (IaC) and modular Terraform best practices.

The Storage module consumes outputs from previously deployed Terraform modules and stores its own Terraform state remotely in Azure Storage.

---

## Architecture

```
CloudLab Hybrid Azure AVD Lab

            Azure Subscription
                    |
            rg-storage-dev
                    |
        +--------------------------+
        |  Azure Storage Account   |
        |  stcloudlabdev01         |
        +--------------------------+
                    |
                    |
            Blob Service
                    |
        +--------------------------+
        | application-data         |
        | Private Access           |
        +--------------------------+
```

---

## Resources Deployed

| Resource Type | Name |
|---------------|------|
| Storage Account | stcloudlabdev01 |
| Blob Container | application-data |

---

## Storage Account Configuration

| Setting | Value |
|--------|--------|
| Performance Tier | Standard |
| Replication | LRS |
| Storage Kind | StorageV2 |
| HTTPS Only | Enabled |
| Minimum TLS Version | TLS1_2 |
| Infrastructure Encryption | Enabled |
| Public Blob Access | Disabled |
| Hierarchical Namespace | Disabled |
| Public Network Access | Disabled |
| Access Tier | Hot (default) |

---

## Terraform Files

```
01-Storage-Account
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

This module uses an Azure Storage Account backend for remote Terraform state management.

Benefits include:

- State locking
- Remote state storage
- Collaboration support
- Improved security
- Separation of infrastructure modules

---

## Dependencies

This module consumes Terraform remote state outputs from previously deployed infrastructure modules.

Current dependencies:

```
Networking
└── 01-VNET
```

Examples of consumed outputs:

- Resource Group Name
- Virtual Network ID
- Subnet IDs

---

## Outputs

The module exports the following outputs:

| Output | Description |
|-------|-------|
| storage_account_name | Storage Account name |
| storage_account_id | Storage Account Resource ID |
| primary_blob_endpoint | Blob service endpoint |
| blob_container_name | Blob container name |
| blob_container_id | Blob container Resource ID |

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

Current security configurations include:

- HTTPS traffic only
- TLS 1.2 minimum
- Infrastructure encryption enabled
- Public blob access disabled
- Private blob container
- Terraform remote state locking enabled

Future modules will add:

- Azure File Shares
- Private Endpoints
- Private DNS Zones
- FSLogix profile storage
- RBAC configurations

---

## Future Enhancements

The Storage module will later be extended with:

```
Storage
│
├── 01-Storage-Account
├── 02-Azure-File-Share
└── 03-Private-Endpoint
```

These components will provide storage services required for:

- Azure Virtual Desktop
- FSLogix Profiles
- Hybrid Identity
- Domain-joined Session Hosts

---

## Technologies Used

- Microsoft Azure
- Terraform
- Azure CLI
- Git
- Visual Studio Code
- PowerShell 7

---

## Author

**Esau Picado**

CloudLab Hybrid Azure AVD Lab  
Enterprise-grade Hybrid Azure Infrastructure built with Terraform.
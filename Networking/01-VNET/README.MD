# Azure Networking - Virtual Network Deployment

This Terraform project deploys an Azure Virtual Network and multiple subnets as part of my CloudLab hybrid infrastructure environment.

## Objectives

- Deploy Azure networking resources using Terraform
- Design an enterprise-style network architecture
- Prepare the environment for future Azure Virtual Desktop and Hybrid Identity deployments
- Learn Terraform resource dependencies

---

## Technologies

- Microsoft Azure
- Terraform
- Azure CLI
- Visual Studio Code
- Git

---

## Network Design

```
                    Azure

                rg-network-dev

                        |

                   vnet-cloudlab

                   10.10.0.0/16

                        |

------------------------------------------------

|                     |                        |

Management            Servers                  AVD

10.10.1.0/24          10.10.2.0/24            10.10.3.0/24
```

---

## Resources Deployed

### Resource Group

- rg-network-dev

### Virtual Network

- vnet-cloudlab

Address Space:

```
10.10.0.0/16
```

### Subnets

| Subnet | Address Space |
|-------|-------|
| snet-management | 10.10.1.0/24 |
| snet-servers | 10.10.2.0/24 |
| snet-avd | 10.10.3.0/24 |

---

## Future Plans

This network will later be extended to support:

- Network Security Groups
- Azure Bastion
- Azure Virtual Desktop
- Azure Files
- Hybrid Identity
- Site-to-Site VPN concepts
- Hub-and-Spoke architectures
- VNET Peering

---

## Terraform Workflow

```bash
terraform fmt
terraform init
terraform validate
terraform plan
terraform apply
terraform output
terraform state list
terraform show
terraform destroy
```

---

## Project Structure

```
01-VNET
│
├── main.tf
├── providers.tf
├── variables.tf
├── outputs.tf
├── terraform.tfvars
└── README.md
```

---

## Concepts Learned

- Virtual Networks
- Subnets
- Resource dependencies
- Terraform state management
- Infrastructure as Code
- Azure network design principles

---

## Notes

The networking design intentionally follows enterprise cloud architecture principles and will serve as the foundation for future hybrid cloud and Azure Virtual Desktop deployments.

All Azure resources are deployed for learning purposes and destroyed when not in use to minimize cost.
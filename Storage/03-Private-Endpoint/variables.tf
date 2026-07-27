variable "subscription_id" {
  type = string
}

variable "location" {
  type    = string
  default = "eastus"
}

variable "tags" {
  type = map(string)

  default = {
    Environment = "Dev"
    Project     = "CloudLab"
    ManagedBy   = "Terraform"
    Owner       = "Esau"
  }
}
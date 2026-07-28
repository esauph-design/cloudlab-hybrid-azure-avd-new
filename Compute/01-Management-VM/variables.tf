variable "subscription_id" {
  type = string
}
variable "admin_username" {
  type = string
}
variable "admin_password" {
  type = string
  sensitive = true
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
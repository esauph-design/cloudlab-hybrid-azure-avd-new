variable "subscription_id" {
  type = string
}

variable "resource_group_name" {
  type = string
}
variable "location" {
  type = string
}
variable "storage_account_name" {
  type = string
}
variable "account_tier" {
  type = string
}
variable "account_replication_type" {
  type = string
}
variable "account_kind" {
  type = string
}
variable "public_network_access_enabled" {
  type = bool
}
variable "allow_nested_items_to_be_public" {
  type = bool
}
variable "shared_access_key_enabled" {
  type = bool
}
variable "https_traffic_only_enabled" {
  type = bool
}
variable "min_tls_version" {
  type = string
}
variable "tags" {
  type = map(string)
}
variable "container_name" {
  type = string
}
variable "container_access_type" {
  type = string
}
variable "Hierarchical_namespace_enabled" {
  type = bool
}
variable "infrastructure_encryption_enabled" {
  type = bool
}
variable "allow_blob_public_access_enabled" {
  type = bool
}
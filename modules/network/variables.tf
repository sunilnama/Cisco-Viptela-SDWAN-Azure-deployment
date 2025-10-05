variable "resource_group_name" { type = string }
variable "location" { type = string }
variable "vnet_name" { type = string }
variable "address_space" { type = list(string) }
variable "controllers_subnet_name" { type = string }
variable "controllers_subnet_prefix" { type = string }
variable "vedge_subnet_name" { type = string }
variable "vedge_subnet_prefix" { type = string }
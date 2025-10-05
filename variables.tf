variable "location" { 
    type = string 
    }
variable "resource_group_name" { 
    type = string 
    }
variable "controller_vhd_sas" { 
    type = string 
    }
variable "admin_username" {
  type    = string
  default = "azureadmin"
}
variable "admin_password" {
  type      = string
  sensitive = true
}
variable "vnet_name" {
  type    = string
  default = "sdwan-vnet"
}
variable "address_space" {
  type    = list(string)
  default = ["10.0.0.0/16"]
}
variable "controllers_subnet_prefix" {
  type    = string
  default = "10.0.1.0/24"
}
variable "vedge_subnet_prefix" {
  type    = string
  default = "10.0.2.0/24"
}
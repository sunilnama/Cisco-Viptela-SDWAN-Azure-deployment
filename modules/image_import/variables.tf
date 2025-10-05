variable "resource_group_name" { type = string }
variable "location" { type = string }
variable "vhd_source_sas" { type = string }
variable "managed_disk_name" { type = string }
variable "image_name" { type = string }
variable "storage_account_type" {
  type    = string
  default = "Standard_LRS"
}
variable "os_type" {
  type    = string
  default = "Linux"
}
variable "os_state" {
  type    = string
  default = "Specialized"
}
variable "disk_size_gb" {
  type    = number
  default = 128
}
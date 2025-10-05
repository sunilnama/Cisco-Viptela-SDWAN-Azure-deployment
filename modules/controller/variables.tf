variable "name" { type = string }
variable "resource_group_name" { type = string }
variable "location" { type = string }
variable "vm_size" {
  type    = string
  default = "Standard_DS3_v2"
}
variable "controllers_subnet_id" { type = string }
variable "private_ip_allocation" {
  type    = string
  default = "Static"
}
variable "private_ip" { type = string }
variable "public_ip_id" {
  type    = string
  default = null
}
variable "admin_username" { type = string }
variable "admin_password" {
  type      = string
  sensitive = true
}
variable "source_image_id" { type = string }
variable "os_disk_size_gb" {
  type    = number
  default = 128
}
variable "tags" {
  type    = map(string)
  default = {}
}
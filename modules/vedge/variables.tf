variable "name" { type = string }
variable "resource_group_name" { type = string }
variable "location" { type = string }
variable "vedge_subnet_id" { type = string }
variable "vm_size" {
  type    = string
  default = "Standard_B2ms"
}
variable "admin_username" { type = string }
variable "admin_password" {
  type      = string
  sensitive = true
}
variable "marketplace_publisher" {
  type    = string
  default = "cisco"
}
variable "marketplace_offer" {
  type    = string
  default = "cisco-catalyst-8000v"
}
variable "marketplace_sku" {
  type    = string
  default = "byol"
}
variable "marketplace_version" {
  type    = string
  default = "latest"
}
variable "os_disk_size_gb" {
  type    = number
  default = 64
}
variable "tags" {
  type    = map(string)
  default = {}
}
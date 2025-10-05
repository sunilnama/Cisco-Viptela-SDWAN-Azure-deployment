variable "name" { type = string }
variable "resource_group_name" { type = string }
variable "location" { type = string }
variable "admin_username" { type = string }
variable "admin_ssh_key" { type = string }
variable "subnet_ids" { type = map(string) } # map of logical name -> subnet id
variable "image" {
  type = object({
    publisher = string
    offer     = string
    sku       = string
    version   = string
  })
}
variable "plan" {
  type = object({
    name      = string
    product   = string
    publisher = string
  })
  default = { name = "", product = "", publisher = "" }
}
variable "size" {
  type    = string
  default = "Standard_DS2_v2"
}
variable "nics" {
  type    = list(string)
  default = []
} # list of subnet keys to attach NICs to

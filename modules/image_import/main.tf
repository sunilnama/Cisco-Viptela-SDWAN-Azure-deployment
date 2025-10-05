resource "azurerm_managed_disk" "controller_disk" {
name = var.managed_disk_name
location = var.location
resource_group_name = var.resource_group_name
storage_account_type = var.storage_account_type
create_option = "Import"
source_uri = var.vhd_source_sas
os_type = var.os_type
disk_size_gb = var.disk_size_gb
}


resource "azurerm_image" "controller_image" {
name = var.image_name
location = var.location
resource_group_name = var.resource_group_name


os_disk {
os_type = var.os_type
os_state = var.os_state
managed_disk_id = azurerm_managed_disk.controller_disk.id
storage_type = var.storage_account_type
}
}


output "image_id" {
value = azurerm_image.controller_image.id
}


output "managed_disk_id" {
value = azurerm_managed_disk.controller_disk.id
}
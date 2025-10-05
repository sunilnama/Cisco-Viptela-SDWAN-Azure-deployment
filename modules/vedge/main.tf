resource "azurerm_network_interface" "this" {
name = "nic-${var.name}"
location = var.location
resource_group_name = var.resource_group_name


ip_configuration {
name = "ipconfig-${var.name}"
subnet_id = var.vedge_subnet_id
private_ip_address_allocation = "Dynamic"
}
}


# Using image reference for Catalyst 8000V (PAYG/BYOL). You may need to accept marketplace terms manually or via az cli.
resource "azurerm_virtual_machine" "this" {
name = var.name
location = var.location
resource_group_name = var.resource_group_name
network_interface_ids = [azurerm_network_interface.this.id]
vm_size = var.vm_size


storage_image_reference {
publisher = var.marketplace_publisher
offer = var.marketplace_offer
sku = var.marketplace_sku
version = var.marketplace_version
}


storage_os_disk {
name = "osdisk-${var.name}"
caching = "ReadWrite"
create_option = "FromImage"
disk_size_gb = var.os_disk_size_gb
}


os_profile {
computer_name = var.name
admin_username = var.admin_username
admin_password = var.admin_password
}


os_profile_linux_config {
disable_password_authentication = false
}


tags = var.tags
}


output "vedge_vm_id" { value = azurerm_virtual_machine.this.id }
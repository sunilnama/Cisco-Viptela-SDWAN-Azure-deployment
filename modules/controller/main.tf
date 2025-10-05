resource "azurerm_network_interface" "this" {
name = "nic-${var.name}"
location = var.location
resource_group_name = var.resource_group_name


ip_configuration {
name = "ipconfig-${var.name}"
subnet_id = var.controllers_subnet_id
private_ip_address_allocation = var.private_ip_allocation
private_ip_address = var.private_ip
public_ip_address_id = var.public_ip_id
}
}


resource "azurerm_linux_virtual_machine" "this" {
name = var.name
location = var.location
resource_group_name = var.resource_group_name
size = var.vm_size
network_interface_ids = [azurerm_network_interface.this.id]


admin_username = var.admin_username
admin_password = var.admin_password


source_image_id = var.source_image_id


os_disk {
caching = "ReadWrite"
disk_size_gb = var.os_disk_size_gb
}


custom_data = base64encode(templatefile("${path.module}/init-controller.sh.tpl", {
hostname = var.name
admin_password = var.admin_password
}))


tags = var.tags
}


# Simple template used to cloud-init / bootstrap
resource "local_file" "init_tpl" {
filename = "${path.module}/init-controller.sh.tpl"
content = <<-EOF
#!/bin/bash
# This template sets hostname and admin password (as example)
hostnamectl set-hostname ${hostname}
# Note: setting Linux user password non-interactively
echo "${admin_password}" | passwd --stdin ${admin_username} || true
# Add any vendor-specific initial steps here (Cisco images may require special handling)
EOF
}


output "vm_id" { value = azurerm_linux_virtual_machine.this.id }
output "nic_id" { value = azurerm_network_interface.this.id }

# Note: passwd --stdin exists on some distros; on others you may need chpasswd or other means.
# The template is illustrative — adapt to the controller image's preferred bootstrap method.
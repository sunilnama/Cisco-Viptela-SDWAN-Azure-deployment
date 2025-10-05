resource "azurerm_virtual_network" "this" {
name = var.vnet_name
location = var.location
resource_group_name = var.resource_group_name
address_space = var.address_space
}


resource "azurerm_subnet" "controllers" {
name = var.controllers_subnet_name
resource_group_name = var.resource_group_name
virtual_network_name = azurerm_virtual_network.this.name
address_prefixes = [var.controllers_subnet_prefix]
}


resource "azurerm_subnet" "vedge" {
name = var.vedge_subnet_name
resource_group_name = var.resource_group_name
virtual_network_name = azurerm_virtual_network.this.name
address_prefixes = [var.vedge_subnet_prefix]
}


resource "azurerm_network_security_group" "controllers_nsg" {
name = "nsg-controllers"
location = var.location
resource_group_name = var.resource_group_name
}


# simple rule allowing ssh and https (adjust per Cisco docs)
resource "azurerm_network_security_rule" "ssh" {
name = "Allow-SSH"
priority = 100
direction = "Inbound"
access = "Allow"
protocol = "Tcp"
source_port_range = "*"
destination_port_ranges = ["22"]
source_address_prefix = "*"
destination_address_prefix = "*"
resource_group_name = var.resource_group_name
network_security_group_name = azurerm_network_security_group.controllers_nsg.name
}


resource "azurerm_public_ip" "vmanage_pip" {
name = "pip-vmanage"
location = var.location
resource_group_name = var.resource_group_name
allocation_method = "Static"
sku = "Standard"
}


output "vnet_id" {
value = azurerm_virtual_network.this.id
}


output "controllers_subnet_id" {
value = azurerm_subnet.controllers.id
}


output "vedge_subnet_id" {
value = azurerm_subnet.vedge.id
}


output "vmanage_pip_ip" {
value = azurerm_public_ip.vmanage_pip.ip_address
}
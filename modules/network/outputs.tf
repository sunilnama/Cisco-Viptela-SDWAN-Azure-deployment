output "controllers_subnet_id" {
value = azurerm_subnet.controllers.id
}


output "vedge_subnet_id" {
value = azurerm_subnet.vedge.id
}


output "vmanage_pip_id" {
value = azurerm_public_ip.vmanage_pip.id
}
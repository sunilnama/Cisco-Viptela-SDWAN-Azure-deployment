resource "azurerm_resource_group" "rg" {
# Resource group definition (add properties if needed)
    name     = var.resource_group_name
    location = var.location
}

module "vbond" {
  source                  = "./modules/controller"
  name                    = "vbond"
  resource_group_name     = azurerm_resource_group.rg.name
  location                = var.location
  vm_size                 = "Standard_DS3_v2"
  controllers_subnet_id   = module.network.controllers_subnet_id
  private_ip_allocation   = "Static"
  private_ip              = "10.0.1.12"
  public_ip_id            = module.network.vbond_public_ip_id
  admin_username          = var.admin_username
  admin_password          = var.admin_password
  source_image_id         = module.image_import.image_id
  os_disk_size_gb         = 160
  tags                    = { role = "vbond" }
}

module "validator" {
  source                  = "./modules/controller"
  name                    = "validator"
  resource_group_name     = azurerm_resource_group.rg.name
  location                = var.location
  vm_size                 = "Standard_DS3_v2"
  controllers_subnet_id   = module.network.controllers_subnet_id
  private_ip_allocation   = "Static"
  private_ip              = "10.0.1.13"
  public_ip_id            = module.network.validator_public_ip_id
  admin_username          = var.admin_username
  admin_password          = var.admin_password
  source_image_id         = module.image_import.image_id
  os_disk_size_gb         = 160
  tags                    = { role = "validator" }
}

# Deploy 1 vEdge (Catalyst 8000V) as an example

module "vedge1" {
  source                  = "./modules/vedge"
  name                    = "vedge-1"
  resource_group_name     = azurerm_resource_group.rg.name
  location                = var.location
  vedge_subnet_id         = module.network.vedge_subnet_id
  admin_username          = var.admin_username
  admin_password          = var.admin_password
  vm_size                 = "Standard_DS3_v2"
  marketplace_offer       = "cisco-c8000v"
  marketplace_publisher   = "cisco"
  marketplace_sku         = "cisco-c8000v"
  marketplace_version     = "latest"
  os_disk_size_gb         = 80
  tags                    = { role = "vedge" }
}
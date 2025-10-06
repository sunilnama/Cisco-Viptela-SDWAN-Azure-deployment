resource "azurerm_resource_group" "rg" {
# Resource group definition (add properties if needed)
    name     = var.resource_group_name
    location = var.location
}

# Network
module "network" {
source = "./modules/network"
resource_group_name = azurerm_resource_group.rg.name
location = var.location
vnet_name = var.vnet_name
address_space = var.address_space
controllers_subnet_name = "controllers-subnet"
controllers_subnet_prefix = var.controllers_subnet_prefix
vedge_subnet_name = "vedge-subnet"
vedge_subnet_prefix = var.vedge_subnet_prefix
}


# Import image from VHD
module "image_import" {
source = "./modules/image_import"


resource_group_name = azurerm_resource_group.rg.name
location = var.location
vhd_source_sas = var.controller_vhd_sas
managed_disk_name = "sdwan-controller-disk"
image_name = "sdwan-controller-image"
os_type = "Linux"
os_state = "Specialized"
disk_size_gb = 160
}


# Controller instances (vManage / vSmart / vBond / Validator) - example using 1 of each

# vManage is the centralized network management system. It provides a single pane of glass for configuring, monitoring, and troubleshooting the entire SD-WAN fabric.
module "vmanage" {
source = "./modules/controller"
name = "vmanage"
resource_group_name = azurerm_resource_group.rg.name
location = var.location
vm_size = "Standard_DS3_v2"
controllers_subnet_id = module.network.controllers_subnet_id
private_ip_allocation = "Static"
private_ip = "10.0.1.10"
public_ip_id = module.network.vmanage_pip_id
admin_username = var.admin_username
admin_password = var.admin_password
source_image_id = module.image_import.image_id
os_disk_size_gb = 160
tags = { role = "vmanage" }
}

# vSmart controller is a central component of the control plane. It plays a critical role in policy management, route distribution, and security across the SD-WAN fabric.
module "vsmart" {
source = "./modules/controller"
name = "vsmart"
resource_group_name = azurerm_resource_group.rg.name
location = var.location
vm_size = "Standard_DS3_v2"
controllers_subnet_id = module.network.controllers_subnet_id
private_ip_allocation = "Static"
private_ip = "10.0.1.11"
admin_username = var.admin_username
admin_password = var.admin_password
source_image_id = module.image_import.image_id
os_disk_size_gb = 160
tags = { role = "vsmart" }
}

# vBond Orchestrator (often referred to as vBond) plays a crucial role in the initial orchestration and authentication of all devices joining the SD-WAN fabric.

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

# Validator is a certificate validation mechanism used during the control plane bring-up process. It ensures that only authorized and trusted devices (like vEdge routers) can join the SD-WAN fabric.
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

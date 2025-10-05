locals {
  nic_names = [for idx, k in var.nics : "${var.name}-nic-${idx}"]
}

# Create NICs for each requested subnet
resource "azurerm_network_interface" "nics" {
  for_each            = toset(var.nics)
  name                = "${var.name}-nic-${each.key}"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = var.subnet_ids[each.value]
    private_ip_address_allocation = "Dynamic"
  }
}

# Optional public IP for first NIC (management)
resource "azurerm_public_ip" "pub" {
  count               = length(var.nics) > 0 ? 1 : 0
  name                = "${var.name}-pip"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
}

# Attach public IP to the first NIC ip_config if created
resource "azurerm_network_interface_backend_address_pool_association" "unused" {
  # placeholder if later needed with LB - not used now
  count                   = 0
  network_interface_id    = azurerm_network_interface.nics[0].id
  ip_configuration_name   = "ipconfig1"
  backend_address_pool_id = "dummy-backend-pool-id"
}

resource "azurerm_linux_virtual_machine" "vm" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  size                = var.size
  admin_username      = var.admin_username
  admin_ssh_key {
    username   = var.admin_username
    public_key = var.admin_ssh_key
  }

  network_interface_ids = [for n in azurerm_network_interface.nics : n.id]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = var.image.publisher
    offer     = var.image.offer
    sku       = var.image.sku
    version   = var.image.version
  }

  # If the image requires marketplace plan info, include the plan block:
  dynamic "plan" {
    for_each = var.plan.name != "" ? [var.plan] : []
    content {
      name      = plan.value.name
      product   = plan.value.product
      publisher = plan.value.publisher
    }
  }

  # cloud-init or custom_data can be passed here to configure the VM on first boot
  # custom_data = base64encode(file("${path.module}/cloud-init/${var.name}-userdata.yaml"))
}

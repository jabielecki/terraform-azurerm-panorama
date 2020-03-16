# Create map of Panoramas that have a logger option enabled. This will created the conditional resource creation. 
locals {
  logger_panoramas = { for name, panorama in var.panoramas : name => panorama if contains(keys(panorama), "logger_size")}
}

# ********** VM NETWORK INTERFACES **********

# Create the network interfaces
resource "azurerm_network_interface" "management" {
  for_each            = var.panoramas
  name                = "${each.key}-PAN-Mgmt"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "${each.key}-ip"
    subnet_id                     = each.value.subnet_id
    private_ip_address_allocation = lookup(each.value, "private_ip_address_allocation", "DYNAMIC")
    private_ip_address            = lookup(each.value, "private_ip_address", null)
    public_ip_address_id          = lookup(each.value, "public_ip_id", null)
  }
}

resource "azurerm_network_interface_security_group_association" "panorama_nsg" {
  for_each                  = var.panoramas
  network_interface_id      = azurerm_network_interface.management[each.key].id
  network_security_group_id = each.value.network_security_group_id
}

# ********** VIRTUAL MACHINE CREATION **********
# TODO 
# set 'admin_ssh_key' up as a dynamic block. 
# add 'password' block with logic that handles 'disable_password_authentication' setting. 

resource "azurerm_linux_virtual_machine" "panorama" {
  for_each              = var.panoramas
  admin_username        = each.value.admin_username
  location              = var.location
  name                  = each.key
  network_interface_ids = [azurerm_network_interface.management[each.key].id]
  resource_group_name   = var.resource_group_name
  size                  = each.value.pan_size

  os_disk {
    name                   = "${each.key}-os-disk"
    caching                = "ReadWrite"
    storage_account_type   = "Premium_LRS"
    disk_encryption_set_id = lookup(each.value, "disk_encryption_set_id", null)
  }

  admin_ssh_key {
    username   = each.value.admin_username
    public_key = each.value.ssh_key
  }

  availability_set_id = lookup(each.value, "availability_set_id", null)

  source_image_reference {
    publisher = var.pan_publisher
    offer     = var.pan_series
    sku       = var.pan_sku
    version   = var.pan_version
  }

  plan {
    name      = var.pan_sku
    product   = var.pan_series
    publisher = var.pan_publisher
  }

  dynamic "boot_diagnostics" {
    for_each = contains(keys(each.value), "storage_account_uri") ? [{}] : []
    content {
      storage_account_uri = boot_diagnostics.key
    }
  }
}

# **** LOGGING DISK CREATION AND ATTACHMENT *****
# TODO - enable encryption options

resource "azurerm_managed_disk" "logging_disk" {
  for_each = local.logger_panoramas
  name                 = "${each.key}-disk1"
  location             = var.location
  resource_group_name  = var.resource_group_name
  storage_account_type = "Standard_LRS"
  create_option        = "Empty"
  disk_size_gb         = each.value.logger_size 
}

resource "azurerm_virtual_machine_data_disk_attachment" "logging_attachment" {
  for_each = local.logger_panoramas
  managed_disk_id    = azurerm_managed_disk.logging_disk[each.key].id
  virtual_machine_id = azurerm_linux_virtual_machine.panorama[each.key].id
  lun                = 10
  caching            = "ReadWrite"
}

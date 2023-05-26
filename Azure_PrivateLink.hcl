# Provider configuration for Azure
provider "azurerm" {
  features {}
}

# Resource group
resource "azurerm_resource_group" "mongodb" {
  name     = "mongodb-resource-group"
  location = "West US"   # Update with your desired location
}

# Virtual network
resource "azurerm_virtual_network" "mongodb" {
  name                = "mongodb-vnet"
  resource_group_name = azurerm_resource_group.mongodb.name
  address_space       = ["10.0.0.0/16"]
}

# Subnet
resource "azurerm_subnet" "mongodb" {
  name                 = "mongodb-subnet"
  resource_group_name  = azurerm_resource_group.mongodb.name
  virtual_network_name = azurerm_virtual_network.mongodb.name
  address_prefixes      = ["10.0.1.0/24"]
}

# Public IP addresses
resource "azurerm_public_ip" "mongodb" {
  count                = 3
  name                 = "mongodb-public-ip-${count.index}"
  resource_group_name  = azurerm_resource_group.mongodb.name
  location             = azurerm_resource_group.mongodb.location
  allocation_method    = "Static"
}

# Network interface cards
resource "azurerm_network_interface" "mongodb" {
  count                = 3
  name                 = "mongodb-nic-${count.index}"
  location             = azurerm_resource_group.mongodb.location
  resource_group_name  = azurerm_resource_group.mongodb.name

  ip_configuration {
    name                          = "mongodb-ip-config-${count.index}"
    subnet_id                     = azurerm_subnet.mongodb.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.mongodb[count.index].id
  }
}

# Virtual machines
resource "azurerm_virtual_machine" "mongodb" {
  count                = 3
  name                 = "mongodb-vm-${count.index}"
  location             = azurerm_resource_group.mongodb.location
  resource_group_name  = azurerm_resource_group.mongodb.name
  vm_size              = "Standard_B2s"
  delete_os_disk_on_termination = true
  delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  storage_os_disk {
    name              = "mongodb-os-disk-${count.index}"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
    disk_size_gb      = 30
  }

  os_profile {
    computer_name  = "mongodb-vm-${count.index}"
    admin_username = "azureuser"
    admin_password = "P@ssw0rd123!"   # Update with your desired admin password
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }

  network_interface_ids = [azurerm_network_interface.mongodb[count.index].id]

  # Enable Private Link for MongoDB
  provisioner "local-exec" {
    command = <<-EOT
      az vm run-command invoke -g ${azurerm_resource_group.mongodb.name} -n ${azurerm_virtual_machine.mongodb[count.index].name} --command-id RunShellScript --scripts 'sudo bash -c "echo '127.0.0.1 mongodb' >> /etc/hosts"'
    EOT
  }

  custom_data = base64

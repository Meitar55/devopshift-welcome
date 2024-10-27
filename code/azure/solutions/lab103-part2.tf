provider "azurerm" {
  features {}
}

variable "admin_username" {
  default = "adminuser-yaniv"
}

variable "admin_password" {
  default = "Password123!"
}

variable "location" {
  default = "East US"
}

variable "vm_size" {
  default = "Standard_B1ms"
}

# Resource Group
resource "azurerm_resource_group" "rg" {
  name     = "rg-yaniv"
  location = var.location
}

# Network Security Group
resource "azurerm_network_security_group" "nsg" {
  name                = "nsg-yaniv"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

# Public IP
resource "azurerm_public_ip" "pip" {
  name                = "pip-yaniv"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Dynamic"
  sku                 = "Basic"
}

# Network Interface
resource "azurerm_network_interface" "nic" {
  name                = "nic-yaniv"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.pip.id
  }
}

# Virtual Network
resource "azurerm_virtual_network" "vnet" {
  name                = "vnet-yaniv"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = ["10.0.0.0/16"]
}

# Subnet
resource "azurerm_subnet" "subnet" {
  name                 = "subnet-yaniv"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

# Linux Virtual Machine
resource "azurerm_linux_virtual_machine" "vm" {
  name                  = "yaniv-vm"
  location              = var.location
  resource_group_name   = azurerm_resource_group.rg.name
  network_interface_ids = [azurerm_network_interface.nic.id]
  size                  = var.vm_size

  os_disk {
    name                 = "yaniv-os-disk"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  admin_username = var.admin_username
  admin_password = var.admin_password

  disable_password_authentication = false
  computer_name                   = "yaniv-vm"

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  lifecycle {
      ignore_changes = [network_interface_ids, public_ip_address]

  }

  depends_on = [azurerm_network_interface.nic, azurerm_public_ip.pip]
}

# Network Security Rule to Allow Port 80 and 22 globally
resource "azurerm_network_security_rule" "allow_http_ssh" {
  name                        = "allow-http-ssh"
  priority                    = 200
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_ranges     = ["80", "22"]
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.rg.name
  network_security_group_name = azurerm_network_security_group.nsg.name
}

# Null Resource for Apache Installation
resource "null_resource" "provision_apache" {
  depends_on = [azurerm_linux_virtual_machine.vm]

  provisioner "remote-exec" {
    inline = [
      "sudo apt update",
      "sudo apt install -y apache2",
      "echo '<h1>Welcome to the Web Server!</h1>' > /var/www/html/welcome.html",
      "sudo systemctl start apache2",
      "sudo systemctl enable apache2"
    ]

    connection {
      type     = "ssh"
      user     = var.admin_username
      password = var.admin_password
      host     = azurerm_public_ip.pip.ip_address
      timeout  = "1m"
    }
  }
}

# Output for Server Info
output "server_info" {
  value       = "Please browse: http://${azurerm_public_ip.pip.ip_address}:80/welcome.html (Port 80 is blocked)"
  description = "Instructions to access the server, noting that port 80 is currently blocked."
}

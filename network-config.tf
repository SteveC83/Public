variable g-core-nw {}

resource "azurerm_virtual_network" "main" {
  name                = "${var.g-core-nw}-network"
  address_space       = ["10.0.0.0/16"]
  location            = "${var.g-location}"
  resource_group_name  = "${var.g-core-rg}"
  depends_on = ["azurerm_resource_group.rg-dev-core-mgmt"]
}

resource "azurerm_subnet" "internal" {
  name                 = "${var.g-core-nw}-internal"
  resource_group_name  = "${var.g-core-rg}"
  virtual_network_name = "${azurerm_virtual_network.main.name}"
  address_prefix       = "10.0.2.0/24"
  depends_on = ["azurerm_virtual_network.main"]
}

resource "azurerm_public_ip" "myterraformpublicip" {
    name                         = "${var.g-core-nw}-PublicIP"
    location                     = "${var.g-location}"
    resource_group_name          = "${var.g-core-rg}"
    depends_on = ["azurerm_virtual_network.main"]
    allocation_method            = "Dynamic"

    tags = {
        environment = "Test"
    }
}

resource "azurerm_network_interface" "main" {
  name                = "${var.g-core-nw}-nic"
  location            = "${var.g-location}"
  resource_group_name = "${var.g-core-rg}"
  depends_on = ["azurerm_virtual_network.main"]

  ip_configuration {
    name                          = "testconfiguration1"
    subnet_id                     = "${azurerm_subnet.internal.id}"
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = "${azurerm_public_ip.myterraformpublicip.id}"
  }
}
resource "azurerm_network_security_group" "myterraformnsg" {
    name                = "testNSG"
    location            = "UK South"
    resource_group_name = "${var.g-core-rg}"
    depends_on = ["azurerm_virtual_network.main"]
    
    security_rule {
        name                       = "RDP"
        priority                   = 1001
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "3389"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
    }

    tags = {
        environment = "Test"
    }
}

resource "azurerm_virtual_network" "azure-network" {
  name                = "azure-network-${var.instance_id}"
  address_space       = ["${var.azure_vpc}"]
  location            = "${azurerm_resource_group.k8s.location}"
  resource_group_name = "${azurerm_resource_group.k8s.name}"

  tags = {
    environment = "Production"
  }
}

resource "azurerm_subnet" "subnet3a" {
  name                 = "subnet3a-${var.instance_id}"
  resource_group_name  = "${azurerm_resource_group.k8s.name}"
  virtual_network_name = "${azurerm_virtual_network.azure-network.name}"
  address_prefix       = "10.243.1.0/24"
  route_table_id       = "${azurerm_route_table.route_subnet3a.id}"
  lifecycle {
    ignore_changes = ["route_table_id", "network_security_group_id"]
  }
}

resource "azurerm_subnet" "subnet3b" {
  name                 = "subnet3b-${var.instance_id}"
  resource_group_name  = "${azurerm_resource_group.k8s.name}"
  virtual_network_name = "${azurerm_virtual_network.azure-network.name}"
  address_prefix       = "10.243.2.0/24"
  route_table_id       = "${azurerm_route_table.route_subnet3b.id}"
  lifecycle {
    ignore_changes = ["route_table_id", "network_security_group_id"]
  }
}
resource "azurerm_subnet" "mygwsubnet" {
  name                 = "GatewaySubnet"
  resource_group_name  = "${azurerm_resource_group.k8s.name}"
  virtual_network_name = "${azurerm_virtual_network.azure-network.name}"
  address_prefix       = "10.243.0.0/24"
}

resource "azurerm_route_table" "route_subnet3a" {
  name                = "RouteTable-a-${var.instance_id}"
  resource_group_name = "${azurerm_resource_group.k8s.name}"
  location            = "${azurerm_resource_group.k8s.location}"
  tags = {
    environment = "Production"
  }
}
resource "azurerm_subnet_route_table_association" "vnet_assoc_a" {
  subnet_id      = "${azurerm_subnet.subnet3a.id}"
  route_table_id = "${azurerm_route_table.route_subnet3a.id}"
}

resource "azurerm_route_table" "route_subnet3b" {
  name                = "RouteTable-b-${var.instance_id}"
  resource_group_name = "${azurerm_resource_group.k8s.name}"
  location            = "${azurerm_resource_group.k8s.location}"
  tags = {
    environment = "Production"
  }
}
resource "azurerm_subnet_route_table_association" "vnet_assoc_b" {
  subnet_id      = "${azurerm_subnet.subnet3b.id}"
  route_table_id = "${azurerm_route_table.route_subnet3b.id}"
}
resource "azurerm_network_security_group" "azure-security-group" {
  name                = "azure-security-group-${var.instance_id}"
  location            = "${azurerm_resource_group.k8s.location}"
  resource_group_name = "${azurerm_resource_group.k8s.name}"

  security_rule {
    name                       = "ALL-IN"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "ALL-OUT"
    priority                   = 1001
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = {
    environment = "Production"
  }
}

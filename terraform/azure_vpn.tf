

resource "azurerm_local_network_gateway" "gcp-test-gw" {
  name = "gcp-test-gw"

  location            = "${azurerm_resource_group.k8s.location}"
  resource_group_name = "${azurerm_resource_group.k8s.name}"

  gateway_address = "${google_compute_address.gcp-vpn-ip.address}"
  address_space   = ["${var.gcp_subnet_vpn}"]
}
resource "azurerm_local_network_gateway" "aws-test-gw" {
  name = "aws-test-gw"

  location            = "${azurerm_resource_group.k8s.location}"
  resource_group_name = "${azurerm_resource_group.k8s.name}"

  gateway_address = "${aws_vpn_connection.aws-vpn-connection2.tunnel1_address}"
  address_space   = ["${var.aws_subnet_vpn}"]
}


resource "azurerm_public_ip" "vpn-ipv4" {
  name                = "vpn-ipv4-${var.instance_id}"
  location            = "${azurerm_resource_group.k8s.location}"
  resource_group_name = "${azurerm_resource_group.k8s.name}"
  allocation_method   = "Dynamic"

  tags = {
    environment = "Terraform Demo"
  }
}

resource "azurerm_virtual_network_gateway" "test" {
  name                = "test-net-gw-${var.instance_id}"
  location            = "${azurerm_resource_group.k8s.location}"
  resource_group_name = "${azurerm_resource_group.k8s.name}"

  type     = "vpn"
  vpn_type = "RouteBased"

  active_active = false
  enable_bgp    = false
  sku           = "HighPerformance"

  ip_configuration {
    name                          = "vnetGatewayConfig"
    public_ip_address_id          = "${azurerm_public_ip.vpn-ipv4.id}"
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = "${azurerm_subnet.mygwsubnet.id}"
  }
}

data "azurerm_public_ip" "vpn-ipv4" {
  name                = "vpn-ipv4-${var.instance_id}"
  resource_group_name = "${azurerm_resource_group.k8s.name}"
  depends_on = [
    "azurerm_virtual_network_gateway.test"
  ]
}

resource "azurerm_virtual_network_gateway_connection" "gcp-test-1" {
  name = "gcp-test-1-${var.instance_id}"

  location            = "${azurerm_resource_group.k8s.location}"
  resource_group_name = "${azurerm_resource_group.k8s.name}"

  type = "IPsec"

  virtual_network_gateway_id = "${azurerm_virtual_network_gateway.test.id}"
  local_network_gateway_id   = "${azurerm_local_network_gateway.gcp-test-gw.id}"

  shared_key = "${random_id.IKEv2.dec}"
}

resource "azurerm_virtual_network_gateway_connection" "gcp-test-2" {
  name = "gcp-test-2-${var.instance_id}"

  location            = "${azurerm_resource_group.k8s.location}"
  resource_group_name = "${azurerm_resource_group.k8s.name}"

  type = "IPsec"

  virtual_network_gateway_id = "${azurerm_virtual_network_gateway.test.id}"
  local_network_gateway_id   = "${azurerm_local_network_gateway.aws-test-gw.id}"

  shared_key = "${aws_vpn_connection.aws-vpn-connection2.tunnel1_preshared_key}"

  depends_on = [
    "aws_vpn_connection.aws-vpn-connection2"
  ]
}

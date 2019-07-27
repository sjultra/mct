/*
 * ----------VPN Connection----------
 */

resource aws_vpn_gateway "aws-vpn-gw" {
  vpc_id = "${aws_vpc.aws_cluster_network.id}"
}

resource aws_customer_gateway "aws-cgw" {
  bgp_asn    = 65000
  ip_address = "${google_compute_address.gcp-vpn-ip.address}"
  type       = "ipsec.1"
  tags = {
    Name = "aws-customer-gw-gcp"
  }
}

resource "aws_vpn_connection" "aws-vpn-connection1" {
  vpn_gateway_id      = "${aws_vpn_gateway.aws-vpn-gw.id}"
  customer_gateway_id = "${aws_customer_gateway.aws-cgw.id}"
  type                = "ipsec.1"

  static_routes_only = true
  tags = {
    Name = "aws-vpn-connection1-${var.instance_id}"
  }
}

resource "aws_vpn_connection_route" "gcp_hybrid_cloud-1" {
  destination_cidr_block = "${var.gcp_subnet_vpn}"
  vpn_connection_id      = "${aws_vpn_connection.aws-vpn-connection1.id}"
}


resource aws_customer_gateway "aws-azgw" {
  bgp_asn    = 65000
  ip_address = "${data.azurerm_public_ip.vpn-ipv4.ip_address}"
  type       = "ipsec.1"
  tags = {
    Name = "aws-customer-gw-azure"
  }
  depends_on = [
    "data.azurerm_public_ip.vpn-ipv4",
  ]
}
resource "aws_vpn_connection" "aws-vpn-connection2" {
  vpn_gateway_id      = "${aws_vpn_gateway.aws-vpn-gw.id}"
  customer_gateway_id = "${aws_customer_gateway.aws-azgw.id}"
  type                = "ipsec.1"

  static_routes_only = true
  tags = {
    Name = "aws-vpn-connection2-${var.instance_id}"
  }
}

resource "aws_vpn_connection_route" "azure_hybrid_cloud-1" {
  destination_cidr_block = "${var.azure_vpc}"
  vpn_connection_id      = "${aws_vpn_connection.aws-vpn-connection2.id}"
}


resource "aws_vpn_gateway_route_propagation" "hybrid_cloud" {
  vpn_gateway_id = "${aws_vpn_gateway.aws-vpn-gw.id}"
  route_table_id = "${aws_route_table.cluster_route_table.id}"
}


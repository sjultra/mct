/*
 * ----------VPN Connection----------
 */

resource "google_compute_address" "gcp-vpn-ip" {
  name   = "gcp-vpn-ip-${var.instance_id}"
  region = "${var.gcp_region}"
}

resource "google_compute_vpn_gateway" "gcp-vpn-gw" {
  name    = "gcp-vpn-gw-${var.gcp_region}-${var.instance_id}"
  network = "${google_compute_network.gcp-network.name}"
  region  = "${var.gcp_region}"
}

resource "google_compute_forwarding_rule" "fr_esp" {
  name        = "fr-esp"
  ip_protocol = "ESP"
  ip_address  = "${google_compute_address.gcp-vpn-ip.address}"
  target      = "${google_compute_vpn_gateway.gcp-vpn-gw.self_link}"
}

resource "google_compute_forwarding_rule" "fr_udp500" {
  name        = "fr-udp500"
  ip_protocol = "UDP"
  port_range  = "500-500"
  ip_address  = "${google_compute_address.gcp-vpn-ip.address}"
  target      = "${google_compute_vpn_gateway.gcp-vpn-gw.self_link}"
}

resource "google_compute_forwarding_rule" "fr_udp4500" {
  name        = "fr-udp4500"
  ip_protocol = "UDP"
  port_range  = "4500-4500"
  ip_address  = "${google_compute_address.gcp-vpn-ip.address}"
  target      = "${google_compute_vpn_gateway.gcp-vpn-gw.self_link}"
}
//START AWS
/*
 * ----------VPN Tunnel1----------
 */

resource "google_compute_vpn_tunnel" "gcp-tunnel1" {
  name          = "gcp-tunnel1-${var.instance_id}"
  peer_ip       = "${aws_vpn_connection.aws-vpn-connection1.tunnel1_address}"
  shared_secret = "${aws_vpn_connection.aws-vpn-connection1.tunnel1_preshared_key}"
  ike_version   = 1

  target_vpn_gateway      = "${google_compute_vpn_gateway.gcp-vpn-gw.self_link}"
  local_traffic_selector  = ["${var.gcp_subnet_vpn}"]
  remote_traffic_selector = ["${var.aws_subnet_vpn}"]

  depends_on = [
    "google_compute_forwarding_rule.fr_esp",
    "google_compute_forwarding_rule.fr_udp500",
    "google_compute_forwarding_rule.fr_udp4500",
  ]
}

resource "google_compute_route" "aws1" {
  name                = "aws-route1-${var.instance_id}"
  dest_range          = "${var.aws_subnet_vpn}"
  network             = "${google_compute_network.gcp-network.self_link}"
  next_hop_vpn_tunnel = "${google_compute_vpn_tunnel.gcp-tunnel1.self_link}"
  priority            = 100
}

// END AWS

/*
 * ----------VPN Tunnel2----------
 */
//START AZURE
resource "google_compute_vpn_tunnel" "gcp-tunnel2" {
  name        = "gcp-tunnel2-${var.instance_id}"
  peer_ip     = "${data.azurerm_public_ip.vpn-ipv4.ip_address}"
  ike_version = 2

  shared_secret = "${random_id.IKEv2.dec}"

  target_vpn_gateway = "${google_compute_vpn_gateway.gcp-vpn-gw.self_link}"

  local_traffic_selector  = ["${var.gcp_subnet_vpn}"]
  remote_traffic_selector = ["${var.azure_vpc}"]

  depends_on = [
    "google_compute_forwarding_rule.fr_esp",
    "google_compute_forwarding_rule.fr_udp500",
    "google_compute_forwarding_rule.fr_udp4500",
    "data.azurerm_public_ip.vpn-ipv4", //!this is important!!!!
  ]
}

resource "google_compute_route" "azure1" {
  name                = "azure-route1-${var.instance_id}"
  dest_range          = "${var.azure_vpc}"
  network             = "${google_compute_network.gcp-network.self_link}"
  next_hop_vpn_tunnel = "${google_compute_vpn_tunnel.gcp-tunnel2.self_link}"
  priority            = 100
  depends_on = [
    "google_compute_vpn_tunnel.gcp-tunnel2"
  ]
}
//END AZURE

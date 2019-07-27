resource "google_compute_firewall" "debug" {
  name    = "debug-firewall-${var.instance_id}"
  network = "${google_compute_network.gcp-network.name}"

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
  }

  source_tags   = ["ssh"]
  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_firewall" "gcp-allow-vpn" {
  name    = "${google_compute_network.gcp-network.name}-gcp-allow-vpn-${var.instance_id}"
  network = "${google_compute_network.gcp-network.name}"

  allow {
    protocol = "tcp"
    ports    = ["0-65535"]
  }

  allow {
    protocol = "udp"
    ports    = ["0-65535"]
  }

  allow {
    protocol = "all"
  }
  source_ranges = [
    "${var.aws_subnet_vpn}",
    "${var.azure_vpc}"
  ]
}

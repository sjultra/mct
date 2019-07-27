data "google_compute_zones" "available" {}

resource "google_compute_network" "gcp-network" {
  name                    = "gcp-network-${var.instance_id}"
  auto_create_subnetworks = "false"
}

resource "google_compute_subnetwork" "subnet1a" {
  name          = "subnet1a-${var.instance_id}"
  ip_cidr_range = "${var.gcp_subnet1a}"
  network       = "${google_compute_network.gcp-network.name}"
  region        = "${var.gcp_region}"
}

resource "google_compute_subnetwork" "subnet1b" {
  name          = "subnet1b-${var.instance_id}"
  ip_cidr_range = "${var.gcp_subnet1b}"
  network       = "${google_compute_network.gcp-network.name}"
  region        = "${var.gcp_region}"
}

resource "google_container_cluster" "k8s1a" {
  name               = "k8s1a-${var.instance_id}"
  location           = "${data.google_compute_zones.available.names[0]}"
  network            = "${google_compute_network.gcp-network.self_link}"
  subnetwork         = "${google_compute_subnetwork.subnet1a.self_link}"
  min_master_version = "latest"

  addons_config {
    network_policy_config {
      disabled = true
    }
  }

  master_auth {
    username = "${var.gcp_k8s_username}"
    password = "${var.gcp_k8s_password}"
  }

  node_pool {
    name       = "k8s1a-node-pool-${var.instance_id}"
    node_count = "${var.gcp_k8s_worker_count}"

    autoscaling {
      min_node_count = 0
      max_node_count = "${var.gcp_k8s_worker_count_max}"
    }

    node_config {
      preemptible  = false
      disk_size_gb = 100
      machine_type = "${var.gcp_k8s_worker_size}"
      oauth_scopes = [
        "https://www.googleapis.com/auth/devstorage.read_only",
        "https://www.googleapis.com/auth/logging.write",
        "https://www.googleapis.com/auth/monitoring",
        "https://www.googleapis.com/auth/service.management.readonly",
        "https://www.googleapis.com/auth/servicecontrol",
        "https://www.googleapis.com/auth/trace.append",
        "https://www.googleapis.com/auth/compute",
      ]
    }
  }
}

resource "google_container_cluster" "k8s1b" {
  name               = "k8s1b-${var.instance_id}"
  location           = "${data.google_compute_zones.available.names[0]}"
  network            = "${google_compute_network.gcp-network.self_link}"
  subnetwork         = "${google_compute_subnetwork.subnet1b.self_link}"
  min_master_version = "latest"

  addons_config {
    network_policy_config {
      disabled = true
    }
  }

  master_auth {
    username = "${var.gcp_k8s_username}"
    password = "${var.gcp_k8s_password}"
  }

  node_pool {
    name       = "k8s1b-node-pool-${var.instance_id}"
    node_count = "${var.gcp_k8s_worker_count}"

    autoscaling {
      min_node_count = 0
      max_node_count = "${var.gcp_k8s_worker_count_max}"
    }

    node_config {
      preemptible  = false
      disk_size_gb = 100
      machine_type = "${var.gcp_k8s_worker_size}"
      oauth_scopes = [
        "https://www.googleapis.com/auth/devstorage.read_only",
        "https://www.googleapis.com/auth/logging.write",
        "https://www.googleapis.com/auth/monitoring",
        "https://www.googleapis.com/auth/service.management.readonly",
        "https://www.googleapis.com/auth/servicecontrol",
        "https://www.googleapis.com/auth/trace.append",
        "https://www.googleapis.com/auth/compute",
      ]
    }
  }
}


locals {
  vm1a_private_ip = "10.241.1.100"
  vm1b_private_ip = "10.241.2.100"
  vm1c_private_ip = "10.241.1.200"
  vm1d_private_ip = "10.241.2.200"
}

data "template_file" "metadata_startup_script_ubuntu_a" {
  template = "${file("install_os_u_deps.sh")}"
  vars = {
    env_aws          = "false"
    host_name        = "ubuntu"
    new_user_a       = "auser"
    new_user_b       = "buser"
    user_password    = "testpassword"
    user_key         = "${file("${var.public_ssh_key}")}"
    user_private_key = "${file("${var.private_ssh_key}")}"
  }
}

data "template_file" "metadata_startup_script_centos_c" {
  template = "${file("install_os_r_deps.sh")}"
  vars = {
    env_aws          = "false"
    host_name        = "redhat"
    new_user_a       = "auser"
    new_user_b       = "buser"
    user_password    = "testpassword"
    user_key         = "${file("${var.public_ssh_key}")}"
    user_private_key = "${file("${var.private_ssh_key}")}"
  }
}

data "template_file" "metadata_startup_script_ubuntu_b" {
  template = "${file("install_os_u_deps.sh")}"
  vars = {
    env_aws          = "false"
    host_name        = "ubuntu"
    new_user_a       = "auser"
    new_user_b       = "buser"
    user_password    = "testpassword"
    user_key         = "${file("${var.public_ssh_key}")}"
    user_private_key = "${file("${var.private_ssh_key}")}"
  }
}

data "template_file" "metadata_startup_script_centos_d" {
  template = "${file("install_os_r_deps.sh")}"
  vars = {
    env_aws          = "false"
    host_name        = "redhat"
    new_user_a       = "auser"
    new_user_b       = "buser"
    user_password    = "testpassword"
    user_key         = "${file("${var.public_ssh_key}")}"
    user_private_key = "${file("${var.private_ssh_key}")}"
  }
}

resource "google_compute_address" "vm1a-ipv4" {
  name = "vm1a-ipv4-${var.instance_id}"
}

resource "google_compute_address" "vm1b-ipv4" {
  name = "vm1b-ipv4-${var.instance_id}"
}

resource "google_compute_address" "vm1c-ipv4" {
  name = "vm1c-ipv4-${var.instance_id}"
}

resource "google_compute_address" "vm1d-ipv4" {
  name = "vm1d-ipv4-${var.instance_id}"
}

resource "google_compute_instance" "vm1a" {
  name         = "vm1a-${var.instance_id}"
  machine_type = "${var.gcp_vms_size}"
  zone         = "${data.google_compute_zones.available.names[0]}"


  boot_disk {
    initialize_params {
      image = "${var.gcp_os_u}"
    }
  }

  metadata_startup_script = "${data.template_file.metadata_startup_script_ubuntu_a.rendered}"

  metadata = {
    ssh-keys = "${var.gcp_vm_username}:${file("${var.public_ssh_key}")}"
  }

  network_interface {
    subnetwork = "${google_compute_subnetwork.subnet1a.name}"
    network_ip = "${local.vm1a_private_ip}"
    access_config {
      nat_ip = "${google_compute_address.vm1a-ipv4.address}"
    }
  }
}

resource "google_compute_instance" "vm1b" {
  name         = "vm1b-${var.instance_id}"
  machine_type = "${var.gcp_vms_size}"
  zone         = "${data.google_compute_zones.available.names[0]}"

  boot_disk {
    initialize_params {
      image = "${var.gcp_os_u}"
    }
  }

  metadata_startup_script = "${data.template_file.metadata_startup_script_ubuntu_b.rendered}"

  metadata = {
    ssh-keys = "${var.gcp_vm_username}:${file("${var.public_ssh_key}")}"
  }

  network_interface {
    subnetwork = "${google_compute_subnetwork.subnet1b.name}"
    network_ip = "${local.vm1b_private_ip}"
    access_config {
      nat_ip = "${google_compute_address.vm1b-ipv4.address}"
    }
  }
}


resource "google_compute_instance" "vm1c" {
  name         = "vm1c-${var.instance_id}"
  machine_type = "${var.gcp_vms_size}"
  zone         = "${data.google_compute_zones.available.names[0]}"

  boot_disk {
    initialize_params {
      image = "${var.gcp_os_r}"
    }
  }

  metadata_startup_script = "${data.template_file.metadata_startup_script_centos_c.rendered}"

  metadata = {
    ssh-keys = "${var.gcp_vm_username}:${file("${var.public_ssh_key}")}"
  }

  network_interface {
    subnetwork = "${google_compute_subnetwork.subnet1a.name}"
    network_ip = "${local.vm1c_private_ip}"
    access_config {
      nat_ip = "${google_compute_address.vm1c-ipv4.address}"
    }
  }
}

resource "google_compute_instance" "vm1d" {
  name         = "vm1d-${var.instance_id}"
  machine_type = "${var.gcp_vms_size}"
  zone         = "${data.google_compute_zones.available.names[0]}"

  boot_disk {
    initialize_params {
      image = "${var.gcp_os_r}"
    }
  }

  metadata_startup_script = "${data.template_file.metadata_startup_script_centos_d.rendered}"

  metadata = {
    ssh-keys = "${var.gcp_vm_username}:${file("${var.public_ssh_key}")}"
  }

  network_interface {
    subnetwork = "${google_compute_subnetwork.subnet1b.name}"
    network_ip = "${local.vm1d_private_ip}"
    access_config {
      nat_ip = "${google_compute_address.vm1d-ipv4.address}"
    }
  }
}


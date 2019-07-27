resource "azurerm_kubernetes_cluster" "k8s3a" {
  name                = "k8s3a-${var.instance_id}"
  location            = "${azurerm_resource_group.k8s.location}"
  resource_group_name = "${azurerm_resource_group.k8s.name}"
  dns_prefix          = "mctazdns"

  kubernetes_version = "1.14.6"

  linux_profile {
    admin_username = "${var.azure_k8s_username}"

    ssh_key {
      key_data = "${file("${var.public_ssh_key}")}"
    }
  }

  agent_pool_profile {
    name            = "default"
    count           = "${var.azure_k8s_worker_count}"
    vm_size         = "${var.azure_k8s_worker_size}"
    os_type         = "Linux"
    os_disk_size_gb = 30

    vnet_subnet_id = "${azurerm_subnet.subnet3a.id}"
  }

  service_principal {
    client_id     = "${var.azure_client_id}"
    client_secret = "${var.azure_client_secret}"
  }

  tags = {
    Environment = "Production"
  }
}

resource "azurerm_kubernetes_cluster" "k8s3b" {
  name                = "k8s3b-${var.instance_id}"
  location            = "${azurerm_resource_group.k8s.location}"
  resource_group_name = "${azurerm_resource_group.k8s.name}"
  dns_prefix          = "mctazdns"

  kubernetes_version = "1.14.6"

  linux_profile {
    admin_username = "${var.azure_k8s_username}"

    ssh_key {
      key_data = "${file("${var.public_ssh_key}")}"
    }
  }

  agent_pool_profile {
    name            = "default"
    count           = "${var.azure_k8s_worker_count}"
    vm_size         = "${var.azure_k8s_worker_size}"
    os_type         = "Linux"
    os_disk_size_gb = 30

    vnet_subnet_id = "${azurerm_subnet.subnet3b.id}"
  }

  service_principal {
    client_id     = "${var.azure_client_id}"
    client_secret = "${var.azure_client_secret}"
  }

  tags = {
    Environment = "Production"
  }
}

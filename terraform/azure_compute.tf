resource "azurerm_resource_group" "k8s" {
  name     = "j19mct-${var.instance_id}"
  location = "${var.azure_region}"
}

resource "azurerm_public_ip" "vm3a-ipv4" {
  name                = "vm3a-ipv4-${var.instance_id}"
  location            = "${azurerm_resource_group.k8s.location}"
  resource_group_name = "${azurerm_resource_group.k8s.name}"
  allocation_method   = "Dynamic"

  tags = {
    environment = "Production"
  }
}

resource "azurerm_public_ip" "vm3b-ipv4" {
  name                = "vm3b-ipv4-${var.instance_id}"
  location            = "${azurerm_resource_group.k8s.location}"
  resource_group_name = "${azurerm_resource_group.k8s.name}"
  allocation_method   = "Dynamic"

  tags = {
    environment = "Production"
  }
}

resource "azurerm_public_ip" "vm3c-ipv4" {
  name                = "vm3c-ipv4-${var.instance_id}"
  location            = "${azurerm_resource_group.k8s.location}"
  resource_group_name = "${azurerm_resource_group.k8s.name}"
  allocation_method   = "Dynamic"

  tags = {
    environment = "Production"
  }
}

resource "azurerm_public_ip" "vm3d-ipv4" {
  name                = "vm3d-ipv4-${var.instance_id}"
  location            = "${azurerm_resource_group.k8s.location}"
  resource_group_name = "${azurerm_resource_group.k8s.name}"
  allocation_method   = "Dynamic"

  tags = {
    environment = "Production"
  }
}


data "azurerm_public_ip" "vm3a-ipv4" {
  name                = "${azurerm_public_ip.vm3a-ipv4.name}"
  resource_group_name = "${azurerm_resource_group.k8s.name}"

  depends_on = [
    "azurerm_virtual_machine.vm3a"
  ]
}

data "azurerm_public_ip" "vm3b-ipv4" {
  name                = "${azurerm_public_ip.vm3b-ipv4.name}"
  resource_group_name = "${azurerm_resource_group.k8s.name}"

  depends_on = [
    "azurerm_virtual_machine.vm3b"
  ]
}

data "azurerm_public_ip" "vm3c-ipv4" {
  name                = "${azurerm_public_ip.vm3c-ipv4.name}"
  resource_group_name = "${azurerm_resource_group.k8s.name}"

  depends_on = [
    "azurerm_virtual_machine.vm3c"
  ]
}

data "azurerm_public_ip" "vm3d-ipv4" {
  name                = "${azurerm_public_ip.vm3d-ipv4.name}"
  resource_group_name = "${azurerm_resource_group.k8s.name}"

  depends_on = [
    "azurerm_virtual_machine.vm3d"
  ]
}


resource "azurerm_network_interface" "vm3a-nic" {
  name                      = "vm3a-nic-${var.instance_id}"
  location                  = "${azurerm_resource_group.k8s.location}"
  resource_group_name       = "${azurerm_resource_group.k8s.name}"
  network_security_group_id = "${azurerm_network_security_group.azure-security-group.id}"

  ip_configuration {
    name                          = "nic-config"
    subnet_id                     = "${azurerm_subnet.subnet3a.id}"
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = "${azurerm_public_ip.vm3a-ipv4.id}"
  }

  tags = {
    environment = "Production"
  }
}

resource "azurerm_network_interface" "vm3b-nic" {
  name                      = "vm3b-nic-${var.instance_id}"
  location                  = "${azurerm_resource_group.k8s.location}"
  resource_group_name       = "${azurerm_resource_group.k8s.name}"
  network_security_group_id = "${azurerm_network_security_group.azure-security-group.id}"

  ip_configuration {
    name                          = "nic-config"
    subnet_id                     = "${azurerm_subnet.subnet3b.id}"
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = "${azurerm_public_ip.vm3b-ipv4.id}"
  }

  tags = {
    environment = "Production"
  }
}

resource "azurerm_network_interface" "vm3c-nic" {
  name                      = "vm3c-nic-${var.instance_id}"
  location                  = "${azurerm_resource_group.k8s.location}"
  resource_group_name       = "${azurerm_resource_group.k8s.name}"
  network_security_group_id = "${azurerm_network_security_group.azure-security-group.id}"

  ip_configuration {
    name                          = "nic-config"
    subnet_id                     = "${azurerm_subnet.subnet3a.id}"
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = "${azurerm_public_ip.vm3c-ipv4.id}"
  }

  tags = {
    environment = "Production"
  }
}

resource "azurerm_network_interface" "vm3d-nic" {
  name                      = "vm3d-nic-${var.instance_id}"
  location                  = "${azurerm_resource_group.k8s.location}"
  resource_group_name       = "${azurerm_resource_group.k8s.name}"
  network_security_group_id = "${azurerm_network_security_group.azure-security-group.id}"

  ip_configuration {
    name                          = "nic-config"
    subnet_id                     = "${azurerm_subnet.subnet3b.id}"
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = "${azurerm_public_ip.vm3d-ipv4.id}"
  }

  tags = {
    environment = "Production"
  }
}

resource "azurerm_virtual_machine" "vm3a" {
  name                  = "vm3a-${var.instance_id}"
  location              = "${azurerm_resource_group.k8s.location}"
  resource_group_name   = "${azurerm_resource_group.k8s.name}"
  network_interface_ids = ["${azurerm_network_interface.vm3a-nic.id}"]
  vm_size               = "${var.azure_vms_size}"

  storage_os_disk {
    name              = "osdisk-a-${var.instance_id}"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Premium_LRS"
  }

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04.0-LTS"
    version   = "latest"
  }

  os_profile {
    computer_name  = "vm3a-${var.instance_id}"
    admin_username = "${var.azure_vm_username}"
    custom_data    = "${data.template_file.install_ubuntu_deps_vm3a.rendered}"
  }

  os_profile_linux_config {
    disable_password_authentication = true
    ssh_keys {
      path     = "/home/${var.azure_vm_username}/.ssh/authorized_keys"
      key_data = "${file("${var.public_ssh_key}")}"
    }
  }

  tags = {
    environment = "Production"
  }
}

resource "azurerm_virtual_machine" "vm3b" {
  name                  = "vm3b-${var.instance_id}"
  location              = "${azurerm_resource_group.k8s.location}"
  resource_group_name   = "${azurerm_resource_group.k8s.name}"
  network_interface_ids = ["${azurerm_network_interface.vm3b-nic.id}"]
  vm_size               = "${var.azure_vms_size}"

  storage_os_disk {
    name              = "osdisk-b-${var.instance_id}"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Premium_LRS"
  }

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04.0-LTS"
    version   = "latest"
  }

  os_profile {
    computer_name  = "vm3b-${var.instance_id}"
    admin_username = "${var.azure_vm_username}"
    custom_data    = "${data.template_file.install_ubuntu_deps_vm3b.rendered}"
  }

  os_profile_linux_config {
    disable_password_authentication = true
    ssh_keys {
      path     = "/home/${var.azure_vm_username}/.ssh/authorized_keys"
      key_data = "${file("${var.public_ssh_key}")}"
    }
  }

  tags = {
    environment = "Production"
  }
}

resource "azurerm_virtual_machine" "vm3c" {
  name                  = "vm3c-${var.instance_id}"
  location              = "${azurerm_resource_group.k8s.location}"
  resource_group_name   = "${azurerm_resource_group.k8s.name}"
  network_interface_ids = ["${azurerm_network_interface.vm3c-nic.id}"]
  vm_size               = "${var.azure_vms_size}"

  storage_os_disk {
    name              = "osdisk-c-${var.instance_id}"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Premium_LRS"
  }

  storage_image_reference {
    publisher = "RedHat"
    offer     = "RHEL"
    sku       = "7-RAW-CI"
    version   = "7.6.2019072418"
  }

  os_profile {
    computer_name  = "vm3c-${var.instance_id}"
    admin_username = "${var.azure_vm_username}"
    custom_data    = "${data.template_file.install_centos_deps_vm3c.rendered}"
  }

  os_profile_linux_config {
    disable_password_authentication = true
    ssh_keys {
      path     = "/home/${var.azure_vm_username}/.ssh/authorized_keys"
      key_data = "${file("${var.public_ssh_key}")}"
    }
  }

  tags = {
    environment = "Production"
  }
}

resource "azurerm_virtual_machine" "vm3d" {
  name                  = "vm3d-${var.instance_id}"
  location              = "${azurerm_resource_group.k8s.location}"
  resource_group_name   = "${azurerm_resource_group.k8s.name}"
  network_interface_ids = ["${azurerm_network_interface.vm3d-nic.id}"]
  vm_size               = "${var.azure_vms_size}"

  storage_os_disk {
    name              = "osdisk-d-${var.instance_id}"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Premium_LRS"
  }

  storage_image_reference {
    publisher = "RedHat"
    offer     = "RHEL"
    sku       = "7-RAW-CI"
    version   = "7.6.2019072418"
  }

  os_profile {
    computer_name  = "vm3d-${var.instance_id}"
    admin_username = "${var.azure_vm_username}"
    custom_data    = "${data.template_file.install_centos_deps_vm3d.rendered}"
  }

  os_profile_linux_config {
    disable_password_authentication = true
    ssh_keys {
      path     = "/home/${var.azure_vm_username}/.ssh/authorized_keys"
      key_data = "${file("${var.public_ssh_key}")}"
    }
  }

  tags = {
    environment = "Production"
  }
}

data "template_file" "install_ubuntu_deps_vm3a" {
  template = "${file("install_os_u_deps.sh")}"
  vars = {
    env_aws          = "false"
    host_name        = ""
    new_user_a       = "auser"
    new_user_b       = "buser"
    user_password    = "testpassword"
    user_key         = "${file("${var.public_ssh_key}")}"
    user_private_key = "${file("${var.private_ssh_key}")}"
  }
}

data "template_file" "install_ubuntu_deps_vm3b" {
  template = "${file("install_os_u_deps.sh")}"
  vars = {
    env_aws          = "false"
    host_name        = ""
    new_user_a       = "auser"
    new_user_b       = "buser"
    user_password    = "testpassword"
    user_key         = "${file("${var.public_ssh_key}")}"
    user_private_key = "${file("${var.private_ssh_key}")}"
  }
}

data "template_file" "install_centos_deps_vm3c" {
  template = "${file("install_os_r_deps.sh")}"
  vars = {
    env_aws          = "false"
    host_name        = ""
    new_user_a       = "auser"
    new_user_b       = "buser"
    user_password    = "testpassword"
    user_key         = "${file("${var.public_ssh_key}")}"
    user_private_key = "${file("${var.private_ssh_key}")}"
  }
}

data "template_file" "install_centos_deps_vm3d" {
  template = "${file("install_os_r_deps.sh")}"
  vars = {
    env_aws          = "false"
    host_name        = ""
    new_user_a       = "auser"
    new_user_b       = "buser"
    user_password    = "testpassword"
    user_key         = "${file("${var.public_ssh_key}")}"
    user_private_key = "${file("${var.private_ssh_key}")}"
  }
}

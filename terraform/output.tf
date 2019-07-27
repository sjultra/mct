////////// AWS ///////////////
output "aws_kube_auth" {
  value = "${local.config_map_aws_auth}"
}

output "instance_id" {
  value = "${var.instance_id}"
}
output "gcp_region" {
  value = "${var.gcp_region}"
}
output "aws_region" {
  value = "${var.aws_region}"
}
output "azure_region" {
  value = "${var.azure_region}"
}

# VM Names
output "aws-vm2a-name" {
  value = "vm2a-${var.instance_id}"
}
output "aws-vm2b-name" {
  value = "vm2b-${var.instance_id}"
}
output "aws-vm2c-name" {
  value = "vm2c-${var.instance_id}"
}
output "aws-vm2d-name" {
  value = "vm2d-${var.instance_id}"
}

# Cluster Names
output "aws-k8s2a-name" {
  value = "${aws_eks_cluster.k8s2a.name}"
}
output "aws-k8s2b-name" {
  value = "${aws_eks_cluster.k8s2b.name}"
}

# VM Public IPs
output "aws-vm2a-public-ip" {
  value = "${aws_eip.vm2a-ipv4.public_ip}"
}
output "aws-vm2b-public-ip" {
  value = "${aws_eip.vm2b-ipv4.public_ip}"
}
output "aws-vm2c-public-ip" {
  value = "${aws_eip.vm2c-ipv4.public_ip}"
}
output "aws-vm2d-public-ip" {
  value = "${aws_eip.vm2d-ipv4.public_ip}"
}

# VM Private IPs
output "aws-vm2a-private-ip" {
  value = "${aws_instance.vm2a.private_ip}"
}
output "aws-vm2b-private-ip" {
  value = "${aws_instance.vm2b.private_ip}"
}
output "aws-vm2c-private-ip" {
  value = "${aws_instance.vm2c.private_ip}"
}
output "aws-vm2d-private-ip" {
  value = "${aws_instance.vm2d.private_ip}"
}

////////// Azure ///////////////
output "azure-resource-group-name" {
  value = "${azurerm_resource_group.k8s.name}"
}

# VM Names
output "azure-vm3a-name" {
  value = "${azurerm_virtual_machine.vm3a.name}"
}
output "azure-vm3b-name" {
  value = "${azurerm_virtual_machine.vm3b.name}"
}
output "azure-vm3c-name" {
  value = "${azurerm_virtual_machine.vm3c.name}"
}
output "azure-vm3d-name" {
  value = "${azurerm_virtual_machine.vm3d.name}"
}

# Cluster Names
output "azure-k8s3a-name" {
  value = "${azurerm_kubernetes_cluster.k8s3a.name}"
}
output "azure-k8s3b-name" {
  value = "${azurerm_kubernetes_cluster.k8s3b.name}"
}

# VM Public IPs

output "azure-vm3a-public-ip" {
  value = "${data.azurerm_public_ip.vm3a-ipv4.ip_address}"
}

output "azure-vm3b-public-ip" {
  value = "${data.azurerm_public_ip.vm3b-ipv4.ip_address}"
}

output "azure-vm3c-public-ip" {
  value = "${data.azurerm_public_ip.vm3c-ipv4.ip_address}"
}

output "azure-vm3d-public-ip" {
  value = "${data.azurerm_public_ip.vm3d-ipv4.ip_address}"
}

# VM Private IPs
output "azure-vm3a-private-ip" {
  value = "${azurerm_network_interface.vm3a-nic.private_ip_address}"
}
output "azure-vm3b-private-ip" {
  value = "${azurerm_network_interface.vm3b-nic.private_ip_address}"
}
output "azure-vm3c-private-ip" {
  value = "${azurerm_network_interface.vm3c-nic.private_ip_address}"
}
output "azure-vm3d-private-ip" {
  value = "${azurerm_network_interface.vm3d-nic.private_ip_address}"
}

////////// GCP ///////////////
# VM Names
output "gcp-vm1a-name" {
  value = "${google_compute_instance.vm1a.name}"
}
output "gcp-vm1b-name" {
  value = "${google_compute_instance.vm1b.name}"
}
output "gcp-vm1c-name" {
  value = "${google_compute_instance.vm1c.name}"
}
output "gcp-vm1d-name" {
  value = "${google_compute_instance.vm1d.name}"
}

# Cluster Names
output "gcp-k8s1a-name" {
  value = "${google_container_cluster.k8s1a.name}"
}
output "gcp-k8s1b-name" {
  value = "${google_container_cluster.k8s1b.name}"
}

# VM Public IPs
output "gcp-vm1a-public-ip" {
  value = "${google_compute_address.vm1a-ipv4.address}"
}
output "gcp-vm1b-public-ip" {
  value = "${google_compute_address.vm1b-ipv4.address}"
}
output "gcp-vm1c-public-ip" {
  value = "${google_compute_address.vm1c-ipv4.address}"
}
output "gcp-vm1d-public-ip" {
  value = "${google_compute_address.vm1d-ipv4.address}"
}

# VM Private IPs
output "gcp-vm1a-private-ip" {
  value = "${local.vm1a_private_ip}"
}
output "gcp-vm1b-private-ip" {
  value = "${local.vm1b_private_ip}"
}
output "gcp-vm1c-private-ip" {
  value = "${local.vm1c_private_ip}"
}
output "gcp-vm1d-private-ip" {
  value = "${local.vm1d_private_ip}"
}

resource "aws_key_pair" "vm-ssh-key" {
  key_name   = "vm_id_rsa_test-${var.instance_id}"
  public_key = "${file("${var.public_ssh_key}")}"
}

resource "aws_eip" "vm2a-ipv4" {
  instance                  = "${aws_instance.vm2a.id}"
  associate_with_private_ip = "${var.aws_vma_private_ip}"
  vpc                       = true
}

resource "aws_eip" "vm2b-ipv4" {
  instance                  = "${aws_instance.vm2b.id}"
  associate_with_private_ip = "${var.aws_vmb_private_ip}"
  vpc                       = true
}

resource "aws_eip" "vm2c-ipv4" {
  instance                  = "${aws_instance.vm2c.id}"
  associate_with_private_ip = "${var.aws_vmc_private_ip}"
  vpc                       = true
}

resource "aws_eip" "vm2d-ipv4" {
  instance                  = "${aws_instance.vm2d.id}"
  associate_with_private_ip = "${var.aws_vmd_private_ip}"
  vpc                       = true
}

resource "aws_instance" "vm2a" {
  ami               = "${data.aws_ami.os_u.id}"
  instance_type     = "${var.aws_vms_size}"
  subnet_id         = "${aws_subnet.subnet2a1.id}"
  key_name          = "${aws_key_pair.vm-ssh-key.key_name}"
  availability_zone = "${data.aws_availability_zones.available.names[0]}"

  associate_public_ip_address = true
  private_ip                  = "${var.aws_vma_private_ip}"
  user_data                   = "${data.template_file.install_ubuntu_deps_vm2a.rendered}"

  vpc_security_group_ids = [
    "${aws_security_group.aws-allow-icmp.id}",
    "${aws_security_group.aws-allow-ssh.id}",
    "${aws_security_group.aws-allow-nginx.id}",
    "${aws_security_group.aws-allow-icmp-gcp.id}"

  ]

  tags = {
    Name = "vm2a-${var.instance_id}"
  }
}

resource "aws_instance" "vm2b" {
  ami               = "${data.aws_ami.os_u.id}"
  instance_type     = "${var.aws_vms_size}"
  subnet_id         = "${aws_subnet.subnet2b1.id}"
  key_name          = "${aws_key_pair.vm-ssh-key.key_name}"
  availability_zone = "${data.aws_availability_zones.available.names[0]}"

  associate_public_ip_address = true
  private_ip                  = "${var.aws_vmb_private_ip}"
  user_data                   = "${data.template_file.install_ubuntu_deps_vm2b.rendered}"

  vpc_security_group_ids = [
    "${aws_security_group.aws-allow-icmp.id}",
    "${aws_security_group.aws-allow-ssh.id}",
    "${aws_security_group.aws-allow-nginx.id}",
    "${aws_security_group.aws-allow-icmp-gcp.id}"
  ]

  tags = {
    Name = "vm2b-${var.instance_id}"
  }
}

resource "aws_instance" "vm2c" {
  ami               = "${data.aws_ami.os_r.id}"
  instance_type     = "${var.aws_vms_size}"
  subnet_id         = "${aws_subnet.subnet2a1.id}"
  key_name          = "${aws_key_pair.vm-ssh-key.key_name}"
  availability_zone = "${data.aws_availability_zones.available.names[0]}"

  associate_public_ip_address = true
  private_ip                  = "${var.aws_vmc_private_ip}"
  user_data                   = "${data.template_file.install_centos_deps_vm2c.rendered}"

  vpc_security_group_ids = [
    "${aws_security_group.aws-allow-icmp.id}",
    "${aws_security_group.aws-allow-ssh.id}",
    "${aws_security_group.aws-allow-nginx.id}",
    "${aws_security_group.aws-allow-icmp-gcp.id}"

  ]

  tags = {
    Name = "vm2c-${var.instance_id}"
  }
}

resource "aws_instance" "vm2d" {
  ami               = "${data.aws_ami.os_r.id}"
  instance_type     = "${var.aws_vms_size}"
  subnet_id         = "${aws_subnet.subnet2b1.id}"
  key_name          = "${aws_key_pair.vm-ssh-key.key_name}"
  availability_zone = "${data.aws_availability_zones.available.names[0]}"

  associate_public_ip_address = true
  private_ip                  = "${var.aws_vmd_private_ip}"
  user_data                   = "${data.template_file.install_centos_deps_vm2d.rendered}"

  vpc_security_group_ids = [
    "${aws_security_group.aws-allow-icmp.id}",
    "${aws_security_group.aws-allow-ssh.id}",
    "${aws_security_group.aws-allow-nginx.id}",
    "${aws_security_group.aws-allow-icmp-gcp.id}"

  ]

  tags = {
    Name = "vm2d-${var.instance_id}"
  }
}

data "template_file" "install_ubuntu_deps_vm2a" {
  template = "${file("install_os_u_deps.sh")}"
  vars = {
    env_aws          = "true"
    host_name        = "vm2a-${var.instance_id}"
    new_user_a       = "auser"
    new_user_b       = "buser"
    user_password    = "testpassword"
    user_key         = "${file("${var.public_ssh_key}")}"
    user_private_key = "${file("${var.private_ssh_key}")}"
  }
}

data "template_file" "install_ubuntu_deps_vm2b" {
  template = "${file("install_os_u_deps.sh")}"
  vars = {
    env_aws          = "true"
    host_name        = "vm2b-${var.instance_id}"
    new_user_a       = "auser"
    new_user_b       = "buser"
    user_password    = "testpassword"
    user_key         = "${file("${var.public_ssh_key}")}"
    user_private_key = "${file("${var.private_ssh_key}")}"
  }
}

data "template_file" "install_centos_deps_vm2c" {
  template = "${file("install_os_r_deps.sh")}"
  vars = {
    env_aws          = "true"
    host_name        = "vm2c-${var.instance_id}"
    new_user_a       = "auser"
    new_user_b       = "buser"
    user_password    = "testpassword"
    user_key         = "${file("${var.public_ssh_key}")}"
    user_private_key = "${file("${var.private_ssh_key}")}"
  }
}

data "template_file" "install_centos_deps_vm2d" {
  template = "${file("install_os_r_deps.sh")}"
  vars = {
    env_aws          = "true"
    host_name        = "vm2d-${var.instance_id}"
    new_user_a       = "auser"
    new_user_b       = "buser"
    user_password    = "testpassword"
    user_key         = "${file("${var.public_ssh_key}")}"
    user_private_key = "${file("${var.private_ssh_key}")}"
  }
}

locals {
  k8s2b_name = "k8s2b-${var.instance_id}"
}

resource "aws_eks_cluster" "k8s2b" {
  name     = "${local.k8s2b_name}"
  role_arn = "${aws_iam_role.demo-cluster.arn}"
  version  = "1.14"

  vpc_config {
    security_group_ids = ["${aws_security_group.cluster-security-group.id}"]
    subnet_ids = [
      "${aws_subnet.subnet2b1.id}",
      "${aws_subnet.subnet2b2.id}"
    ]
  }

  depends_on = [
    "aws_iam_role_policy_attachment.demo-cluster-AmazonEKSClusterPolicy",
    "aws_iam_role_policy_attachment.demo-cluster-AmazonEKSServicePolicy",
  ]
}

locals {
  demo-node-userdata-b = <<USERDATA
#!/bin/bash
set -o xtrace
/etc/eks/bootstrap.sh --apiserver-endpoint '${aws_eks_cluster.k8s2b.endpoint}' --b64-cluster-ca '${aws_eks_cluster.k8s2b.certificate_authority.0.data}' '${local.k8s2b_name}'
USERDATA
}

resource "aws_launch_configuration" "k8s2b-launch-config" {
  associate_public_ip_address = true
  iam_instance_profile        = "${aws_iam_instance_profile.demo-node.name}"
  image_id                    = "${data.aws_ami.eks-worker.id}"
  instance_type               = "${var.aws_k8s_worker_size}"
  name_prefix                 = "k8s2b-launch-config"
  security_groups             = ["${aws_security_group.node-security-group-b.id}"]
  user_data_base64            = "${base64encode(local.demo-node-userdata-b)}"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "demo-b" {
  desired_capacity     = "${var.aws_k8s_worker_count}"
  launch_configuration = "${aws_launch_configuration.k8s2b-launch-config.id}"
  max_size             = "${var.aws_k8s_worker_max_count}"
  min_size             = 1
  name                 = "k8s2b-autoscailing-${var.instance_id}"
  vpc_zone_identifier = [
    "${aws_subnet.subnet2b1.id}",
    "${aws_subnet.subnet2b2.id}",
  ]

  tag {
    key                 = "Name"
    value               = "k8s2b-autoscailing-${var.instance_id}"
    propagate_at_launch = true
  }

  tag {
    key                 = "kubernetes.io/cluster/${local.k8s2b_name}"
    value               = "owned"
    propagate_at_launch = true
  }
}


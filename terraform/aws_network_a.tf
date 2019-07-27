resource "aws_subnet" "subnet2a1" {
  availability_zone = "${data.aws_availability_zones.available.names[0]}"
  cidr_block        = "${var.aws_subnet2a1}"
  vpc_id            = "${aws_vpc.aws_cluster_network.id}"

  tags = "${
    map(
      "Name", "aws-subnet2a1",
      "kubernetes.io/cluster/${local.k8s2a_name}", "shared",
    )
  }"
}

resource "aws_subnet" "subnet2a2" {
  availability_zone = "${data.aws_availability_zones.available.names[1]}"
  cidr_block        = "${var.aws_subnet2a2}"
  vpc_id            = "${aws_vpc.aws_cluster_network.id}"

  tags = "${
    map(
      "Name", "aws-subnet2a2",
      "kubernetes.io/cluster/${local.k8s2a_name}", "shared",
    )
  }"
}

resource "aws_route_table_association" "route-subnet2a1" {
  subnet_id      = "${aws_subnet.subnet2a1.id}"
  route_table_id = "${aws_route_table.cluster_route_table.id}"
}

resource "aws_route_table_association" "route-subnet2a2" {
  subnet_id      = "${aws_subnet.subnet2a2.id}"
  route_table_id = "${aws_route_table.cluster_route_table.id}"
}



resource "aws_security_group" "cluster-security-group" {
  name        = "aws-cluster-security-group-${var.instance_id}"
  description = "Cluster communication with worker nodes"
  vpc_id      = "${aws_vpc.aws_cluster_network.id}"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "aws-cluster-security-group-${var.instance_id}"
  }
}

resource "aws_security_group" "node-security-group" {
  name        = "aws-node-security-group-${var.instance_id}"
  description = "Security group for all nodes in the cluster"
  vpc_id      = "${aws_vpc.aws_cluster_network.id}"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = "${
    map(
      "Name", "aws-node-security-group${var.instance_id}",
      "kubernetes.io/cluster/${local.k8s2a_name}", "owned",
    )
  }"
}

resource "aws_security_group_rule" "demo-node-ingress-self" {
  description              = "Allow node to communicate with each other"
  from_port                = 0
  protocol                 = "-1"
  security_group_id        = "${aws_security_group.node-security-group.id}"
  source_security_group_id = "${aws_security_group.node-security-group.id}"
  to_port                  = 65535
  type                     = "ingress"
}

resource "aws_security_group_rule" "demo-node-ingress-cluster" {
  description              = "Allow worker Kubelets and pods to receive communication from the cluster control plane"
  from_port                = 1025
  protocol                 = "tcp"
  security_group_id        = "${aws_security_group.node-security-group.id}"
  source_security_group_id = "${aws_security_group.cluster-security-group.id}"
  to_port                  = 65535
  type                     = "ingress"
}

resource "aws_security_group_rule" "demo-cluster-ingress-node-https" {
  description              = "Allow pods to communicate with the cluster API Server"
  from_port                = 443
  protocol                 = "tcp"
  security_group_id        = "${aws_security_group.cluster-security-group.id}"
  source_security_group_id = "${aws_security_group.node-security-group.id}"
  to_port                  = 443
  type                     = "ingress"
}

resource "aws_security_group_rule" "test_allow_all" {
  type              = "egress"
  from_port         = 8
  to_port           = 0
  protocol          = "icmp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.node-security-group.id}"
}

resource "aws_security_group_rule" "test_allow_all_in" {
  type              = "ingress"
  from_port         = 8
  to_port           = 0
  protocol          = "icmp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.node-security-group.id}"
}

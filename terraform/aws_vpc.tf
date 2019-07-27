data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_vpc" "aws_cluster_network" {
  cidr_block = "${var.aws_vpc_cidr}"

  tags = "${
    map(
      "Name", "aws-cluster-network",
      "kubernetes.io/cluster/${local.k8s2a_name}", "shared",
      "kubernetes.io/cluster/${local.k8s2b_name}", "shared",
    )
  }"
}

resource "aws_internet_gateway" "cluster_gateway" {
  vpc_id = "${aws_vpc.aws_cluster_network.id}"

  tags = {
    Name = "aws-internet-gateway-${var.instance_id}"
  }
}

resource "aws_route_table" "cluster_route_table" {
  vpc_id = "${aws_vpc.aws_cluster_network.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.cluster_gateway.id}"
  }
}

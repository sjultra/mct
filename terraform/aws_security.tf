
resource "aws_security_group" "aws-allow-icmp" {
  name        = "aws-allow-icmp-${var.instance_id}"
  description = "Allow icmp access from anywhere"
  vpc_id      = "${aws_vpc.aws_cluster_network.id}"

  ingress {
    from_port   = 8
    to_port     = 0
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "aws-allow-icmp-gcp" {
  name        = "aws-allow-icmp-gcp-${var.instance_id}"
  description = "Allow icmp access from anywhere"
  vpc_id      = "${aws_vpc.aws_cluster_network.id}"

  ingress {
    from_port   = 8
    to_port     = 0
    protocol    = "icmp"
    cidr_blocks = ["${var.gcp_subnet_vpn}"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["${var.gcp_subnet_vpn}"]
  }
}


resource "aws_security_group" "aws-allow-ssh" {
  name        = "aws-allow-ssh-${var.instance_id}"
  description = "Allow ssh access from anywhere"
  vpc_id      = "${aws_vpc.aws_cluster_network.id}"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "aws-allow-nginx" {
  name        = "aws-allow-nginx-${var.instance_id}"
  description = "Allow nginx access from anywhere"
  vpc_id      = "${aws_vpc.aws_cluster_network.id}"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

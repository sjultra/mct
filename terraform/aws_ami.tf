data "aws_ami" "os_u" {
  most_recent = true

  filter {
    name   = "name"
    values = ["${var.aws_vma_image}"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical publisher id
}

data "aws_ami" "os_r" {
  owners      = ["309956199498"] // Red Hat's account ID.
  most_recent = true

  filter {
    name   = "name"
    values = ["${var.aws_vmb_image}"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
}

data "aws_ami" "eks-worker" {
  filter {
    name   = "name"
    values = ["amazon-eks-node-${aws_eks_cluster.k8s2a.version}-v*"]
  }

  most_recent = true
  owners      = ["602401143452"] # Amazon EKS AMI Account ID
}

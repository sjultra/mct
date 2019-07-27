variable "aws_region" {
  default = "eu-west-2"
  type    = "string"
}
variable "aws_vma_image" {
  default = "ubuntu/images/hvm-ssd/ubuntu-xenial-16.04-amd64-server-*"
  type    = "string"
}

variable "aws_vmb_image" {
  default = "RHEL-7.5*"
  type    = "string"
}
variable "aws_vms_size" {
  default = "t3.micro"
  type    = "string"
}
variable "aws_subnet_vpn" {
  default = "10.242.0.0/16"
  type    = "string"
}
variable "aws_subnet2a1" {
  default = "10.242.1.0/24"
  type    = "string"
}
variable "aws_subnet2a2" {
  default = "10.242.3.0/24"
  type    = "string"
}
variable "aws_subnet2b1" {
  default = "10.242.2.0/24"
  type    = "string"
}
variable "aws_subnet2b2" {
  default = "10.242.4.0/24"
  type    = "string"
}
variable "aws_vpc_cidr" {
  default = "10.242.0.0/16"
  type    = "string"
}
variable "aws_vma_private_ip" {
  default = "10.242.1.100"
  type    = "string"
}
variable "aws_vmb_private_ip" {
  default = "10.242.2.100"
  type    = "string"
}
variable "aws_vmc_private_ip" {
  default = "10.242.1.200"
  type    = "string"
}
variable "aws_vmd_private_ip" {
  default = "10.242.2.200"
  type    = "string"
}

variable "aws_k8s_worker_size" {
  default = "m4.large"
  type    = "string"
}
variable "aws_k8s_worker_count" {
  default = "2"
  type    = "string"
}
variable "aws_k8s_worker_max_count" {
  default = "2"
  type    = "string"
}

variable "aws_token_u" {
  default = ""
  type    = "string"
}

variable "aws_token_r" {
  default = ""
  type    = "string"
}

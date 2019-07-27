variable "gcp_region" {
  default = "europe-north1"
  type    = "string"
}
variable "gcp_subnet_vpn" {
  default = "10.241.0.0/16"
  type    = "string"
}
variable "gcp_subnet1a" {
  default = "10.241.1.0/24"
  type    = "string"
}
variable "gcp_subnet1b" {
  default = "10.241.2.0/24"
  type    = "string"
}
variable "gcp_vms_size" {
  default = "f1-micro"
  type    = "string"
}
variable "gcp_k8s_worker_count" {
  default = "1"
  type    = "string"
}
variable "gcp_k8s_worker_count_max" {
  default = "10"
  type    = "string"
}
variable "gcp_k8s_worker_size" {
  default = "n1-standard-1"
  type    = "string"
}

variable "gcp_os_u" {
  default = "ubuntu-os-cloud/ubuntu-1604-lts"
  type    = "string"
}
variable "gcp_os_r" {
  default = "rhel-cloud/rhel-7"
  type    = "string"
}
variable "gcp_vm_username" {
  default = "ubuntu"
  type    = "string"
}
variable "gcp_k8s_username" {
  default = "ubuntu"
  type    = "string"
}
variable "gcp_k8s_password" {
  default = "Passw0rdbiggerthan16"
  type    = "string"
}

variable "gcp_token_u" {
  default = ""
  type    = "string"
}

variable "gcp_token_r" {
  default = ""
  type    = "string"
}

variable "public_ssh_key" {
  default = "~/.ssh/id_rsa.pub"
  type    = "string"
}

variable "private_ssh_key" {
  default = "~/.ssh/id_rsa"
  type    = "string"
}

variable "instance_id" {
  type = "string"
}
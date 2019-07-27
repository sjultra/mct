
variable "azure_vpc" {
  default = "10.243.0.0/16"
  type    = "string"
}
variable "azure_client_id" {
  default = ""
  type    = "string"
}
variable "azure_client_secret" {
  default = ""
  type    = "string"
}
variable "azure_region" {
  default = "northeurope"
  type    = "string"
}
variable "azure_vms_size" {
  default = "Standard_DS1_v2"
  type    = "string"
}
variable "azure_k8s_worker_count" {
  default = "2"
  type    = "string"
}
variable "azure_k8s_worker_size" {
  default = "Standard_DS1_v2"
  type    = "string"
}
variable "azure_k8s_username" {
  default = "ubuntu"
  type    = "string"
}
variable "azure_vm_username" {
  default = "ubuntu"
  type    = "string"
}

variable "azure_token_u" {
  default = ""
  type    = "string"
}

variable "azure_token_r" {
  default = ""
  type    = "string"
}


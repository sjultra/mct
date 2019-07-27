resource "random_id" "IKEv2" {
  byte_length = 4
}

provider "aws" {
  version = "~> 2.19.0"
  region  = "${var.aws_region}"
}

provider "azurerm" {}

provider "google" {
  project = "lexical-list-244215"
  region  = "${var.gcp_region}"
}

provider "template" {}

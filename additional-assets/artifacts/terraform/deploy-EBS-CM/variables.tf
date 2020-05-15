provider "oci" {
  region = "${var.region}"
}

variable "region" {}

variable "tenancy_ocid" {}

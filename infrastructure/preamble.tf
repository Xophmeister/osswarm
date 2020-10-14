# Standard OpenStack-based module preamble

terraform {
  required_providers {
    openstack = {
      source = "terraform-provider-openstack/openstack"
    }
  }
  required_version = ">= 0.13"
}

variable "cloud" {
  description = "OpenStack cloud identifier, per clouds.yaml"
}

provider "openstack" {
  cloud = var.cloud
}

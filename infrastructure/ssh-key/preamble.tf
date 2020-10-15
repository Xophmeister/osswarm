terraform {
  required_providers {
    local = {
      source = "hashicorp/local"
    }
    openstack = {
      source = "terraform-provider-openstack/openstack"
    }
  }
  required_version = ">= 0.13"
}

variable "cloud" {
  description = "OpenStack cloud identifier, per clouds.yaml"
}

provider "local" {}

provider "openstack" {
  cloud = var.cloud
}

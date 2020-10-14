terraform {
  required_providers {
    openstack = {
      source = "terraform-provider-openstack/openstack"
    }
  }
  required_version = ">= 0.13"
}

provider "openstack" {
  cloud = var.cloud
}

module "security-groups" {
  source = "./security-groups"
  cluster = var.cluster
}

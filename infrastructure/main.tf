terraform {
  required_version = ">= 0.13"
}

variable "cloud" {
  description = "OpenStack cloud identifier, per clouds.yaml"
}

variable "cluster" {
  description = "Name for the cluster infrastructure"
}

module "security-groups" {
  source = "./security-groups"

  cloud = var.cloud
  cluster = var.cluster
}

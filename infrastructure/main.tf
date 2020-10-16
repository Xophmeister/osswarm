variable "cluster" {
  description = "Name for the cluster infrastructure"
}

variable "key" {
  description = "Path to a public key file, for which its private key must exist"
}

module "ssh-key" {
  source = "./ssh-key"

  cloud   = var.cloud
  cluster = var.cluster
  key     = var.key
}

module "security-groups" {
  source = "./security-groups"

  cloud   = var.cloud
  cluster = var.cluster
}

module "network" {
  source = "./network"

  cloud   = var.cloud
  cluster = var.cluster
}

# TODO Needs an instance to attach to
# module "floating-ip" {
#   source = "./floating-ip"
#
#   cloud    = var.cloud
#   cluster  = var.cluster
#   instance = module.manager.id
# }

## Variables ###########################################################

variable "cloud" {
  type        = string
  description = "OpenStack cloud identifier, per clouds.yaml"
}

variable "cluster" {
  type        = string
  description = "Name for the cluster infrastructure"
}

variable "key" {
  type        = string
  description = "Path to a public key file, for which its private key must exist"
}

variable "image" {
  type        = string
  description = "Base image for Docker Swarm nodes"
}

variable "flavour" {
  type        = string
  description = "Machine flavour for Docker Swarm nodes"
}

variable "workers" {
  type        = number
  description = "Number of worker nodes"
}

variable "domain" {
  type        = string
  description = "Domain under which to expose the cluster"
}

variable "management-subdomain" {
  type        = string
  description = "Subdomain under which to expose management access"
}

variable "service-subdomain" {
  type        = string
  description = "Subdomain under which to expose service access"
}

## Infrastructure ######################################################

provider "openstack" {
  cloud = var.cloud
}

module "ssh-key" {
  source = "./ssh-key"

  cluster = var.cluster
  key     = var.key
}

module "security-groups" {
  source = "./security-groups"

  cluster = var.cluster
}

module "network" {
  source = "./network"

  cluster = var.cluster
}

module "cluster" {
  source = "./compute"

  cluster = var.cluster
  image   = var.image
  flavour = var.flavour
  ssh-key = module.ssh-key.name
  network = module.network.id
  workers = var.workers

  security-groups = {
    manager = [
      module.security-groups.swarm.manager,
      module.security-groups.ssh,
      module.security-groups.netdata,
      module.security-groups.services
    ]
    worker = [
      module.security-groups.swarm.worker,
      module.security-groups.ssh,
      module.security-groups.netdata,
      module.security-groups.services
    ]
  }
}

# TODO This does not work as expected...
# module "load-balancer" {
#   source = "./load-balancer"
#
#   cluster = var.cluster
#   network = module.network.id
#   nodes   = module.cluster.nodes
#
#   security-groups = [
#     module.security-groups.services
#   ]
# }

module "ip" {
  source = "./floating-ip"

  cluster       = var.cluster
  manager       = module.cluster.manager
  # load-balancer = module.load-balancer.port
}

module "dns" {
  source = "./dns"

  domain = var.domain

  management = {
    address   = module.ip.management
    subdomain = var.management-subdomain
  }

  # service = {
  #   address   = module.ip.service
  #   subdomain = var.service-subdomain
  # }
}

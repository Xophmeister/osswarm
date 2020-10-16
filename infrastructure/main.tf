## Variables ###########################################################

variable "cloud" {
  description = "OpenStack cloud identifier, per clouds.yaml"
}

variable "cluster" {
  description = "Name for the cluster infrastructure"
}

variable "key" {
  description = "Path to a public key file, for which its private key must exist"
}

variable "image" {
  description = "Base image for Docker Swarm nodes"
}

variable "flavour" {
  description = "Machine flavour for Docker Swarm nodes"
}

variable "workers" {
  description = "Number of worker nodes"
}

## Providers ###########################################################

provider "local" {}

provider "openstack" {
  cloud = var.cloud
}

## Infrastructure ######################################################

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

module "manager" {
  source = "./instance"

  cluster = var.cluster
  image   = var.image
  flavour = var.flavour
  role    = "manager"
  ssh-key = module.ssh-key.name
  network = module.network.id
  security-groups = [
    module.security-groups.swarm.manager,
    module.security-groups.ssh,
    module.security-groups.netdata,
    module.security-groups.services
  ]
}

module "workers" {
  source = "./instance"
  tally  = var.workers

  cluster = var.cluster
  image   = var.image
  flavour = var.flavour
  role    = "worker"
  ssh-key = module.ssh-key.name
  network = module.network.id
  security-groups = [
    module.security-groups.swarm.worker,
    module.security-groups.ssh,
    module.security-groups.netdata,
    module.security-groups.services
  ]
}

module "floating-ip" {
  source = "./floating-ip"

  cluster  = var.cluster
  instance = module.manager.id[0]
}

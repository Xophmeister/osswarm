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

variable "fault-tolerance" {
  type        = number
  description = "Number of tolerable faults"
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

locals {
  # * The number of managers is a function of fault tolerance, per
  #   Docker Swarm's Raft consensus algorithm
  # * Fault tolerance is capped to 3 nodes (i.e., 7 managers)
  # * The managers will only get a load balancer if there's more than
  #   one of them; the whole cluster will always get a load balancer
  # * The number of workers is capped to fit into a /24 block subnet
  #   (i.e., 256 addresses, minus the load balancers and managers)
  managers       = (2 * min(var.fault-tolerance, 3)) + 1
  fault-tolerant = local.managers > 1
  load-balancers = 1 + (local.fault-tolerant ? 1 : 0)
  workers        = min(var.workers, 256 - local.load-balancers - local.managers)
  nodes          = local.managers + local.workers
}

## Infrastructure ######################################################

provider "openstack" {
  cloud       = var.cloud
  use_octavia = true
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

  cluster  = var.cluster
  image    = var.image
  flavour  = var.flavour
  ssh-key  = module.ssh-key.name
  network  = module.network.id
  managers = local.managers
  workers  = local.workers

  security-groups = {
    manager = [
      module.security-groups.base,
      module.security-groups.netdata,
      module.security-groups.services,
      module.security-groups.ssh,
      module.security-groups.swarm.manager
    ]
    worker = [
      module.security-groups.base,
      module.security-groups.netdata,
      module.security-groups.services,
      module.security-groups.ssh,
      module.security-groups.swarm.worker
    ]
  }
}

module "management-load-balancer" {
  source = "./load-balancer"
  count  = local.fault-tolerant ? 1 : 0

  cluster = var.cluster
  role    = "management"
  network = module.network.id
  subnet  = module.network.subnet

  # SSH access
  listen-port = 22
  route-port  = 22
  security-groups = [
    module.security-groups.base,
    module.security-groups.ssh
  ]

  node-count = local.managers
  nodes      = module.cluster.managers.*.address
}

module "service-load-balancer" {
  source = "./load-balancer"

  cluster = var.cluster
  role    = "service"
  network = module.network.id
  subnet  = module.network.subnet

  # HTTP access routed internally to :8080
  listen-port = 80
  route-port  = 8080
  security-groups = [
    module.security-groups.base
  ]

  node-count = local.nodes
  nodes      = concat(module.cluster.managers.*.address,
                      module.cluster.workers.*.address)
}

module "ip" {
  source = "./floating-ip"

  cluster        = var.cluster
  fault-tolerant = local.fault-tolerant
  manager        = local.fault-tolerant ? module.management-load-balancer[0].port : module.cluster.managers[0].id
  services       = module.service-load-balancer.port
}

module "dns" {
  source = "./dns"

  domain = var.domain

  management = {
    address   = module.ip.management
    subdomain = var.management-subdomain
  }

  service = {
    address   = module.ip.service
    subdomain = var.service-subdomain
  }
}

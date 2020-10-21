resource "openstack_compute_servergroup_v2" "server-group" {
  name     = "osswarm-${var.cluster}"
  policies = ["soft-anti-affinity"]
}

module "manager" {
  source = "./instance"

  image           = var.image
  flavour         = var.flavour
  name            = "osswarm-${var.cluster}-manager"
  server-group    = openstack_compute_servergroup_v2.server-group.id
  ssh-key         = var.ssh-key
  network         = var.network
  metadata        = { "role" = "manager" }
  security-groups = var.security-groups.manager
}

module "worker" {
  source = "./instance"
  count  = min(var.workers, 254) # 254 workers + 1 manager + 1 load balancer = /24 block

  image           = var.image
  flavour         = var.flavour
  name            = "osswarm-${var.cluster}-worker-${format("%02d", count.index + 1)}"
  server-group    = openstack_compute_servergroup_v2.server-group.id
  ssh-key         = var.ssh-key
  network         = var.network
  metadata        = { "role" = "worker" }
  security-groups = var.security-groups.worker
}

output "manager" {
  value = module.manager.id
}

output "nodes" {
  value = concat([module.manager.address], module.worker.*.address)
}

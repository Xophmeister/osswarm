# In the absence of availability zones, we use hypervisor affinity to
# simulate partitioning for fault tolerance
# TODO Switch to strict anti-affinity when resource is available
resource "openstack_compute_servergroup_v2" "manager-group" {
  name     = "osswarm-${var.cluster}-managers"
  policies = ["soft-anti-affinity"]
}

resource "openstack_compute_servergroup_v2" "worker-group" {
  name     = "osswarm-${var.cluster}-workers"
  policies = ["soft-anti-affinity"]
}

module "managers" {
  source = "./instance"
  count  = var.managers

  image           = var.image
  flavour         = var.flavour
  name            = "osswarm-${var.cluster}-manager-${format("%02d", count.index + 1)}"
  server-group    = openstack_compute_servergroup_v2.manager-group.id
  ssh-key         = var.ssh-key
  network         = var.network
  metadata        = { "role" = "manager" }
  security-groups = var.security-groups.manager
}

module "workers" {
  source = "./instance"
  count  = var.workers

  image           = var.image
  flavour         = var.flavour
  name            = "osswarm-${var.cluster}-worker-${format("%02d", count.index + 1)}"
  server-group    = openstack_compute_servergroup_v2.worker-group.id
  ssh-key         = var.ssh-key
  network         = var.network
  metadata        = { "role" = "worker" }
  security-groups = var.security-groups.worker
}

output "managers" {
  value = module.managers
}

output "workers" {
  value = module.workers
}

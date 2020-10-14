resource "openstack_networking_secgroup_v2" "osswarm-manager" {
  name                  = "osswarm-${var.cluster}-manager"
  description           = "Docker Swarm Manager Access"
  delete_default_rules  = true
}

resource "openstack_networking_secgroup_v2" "osswarm-worker" {
  name                  = "osswarm-${var.cluster}-worker"
  description           = "Docker Swarm Worker Access"
  delete_default_rules  = true
}

# FIXME Is the full Cartesian product of rules required for the Docker
# Swarm manager and workers?...

module "manager-to-manager" {
  source = "./swarm"

  cloud = var.cloud
  from = openstack_networking_secgroup_v2.osswarm-manager.id
  to = openstack_networking_secgroup_v2.osswarm-manager.id
}

module "manager-to-worker" {
  source = "./swarm"

  cloud = var.cloud
  from = openstack_networking_secgroup_v2.osswarm-manager.id
  to = openstack_networking_secgroup_v2.osswarm-worker.id
}

module "worker-to-manager" {
  source = "./swarm"

  cloud = var.cloud
  from = openstack_networking_secgroup_v2.osswarm-worker.id
  to = openstack_networking_secgroup_v2.osswarm-manager.id
}

module "worker-to-worker" {
  source = "./swarm"

  cloud = var.cloud
  from = openstack_networking_secgroup_v2.osswarm-worker.id
  to = openstack_networking_secgroup_v2.osswarm-worker.id
}

output "swarm" {
  value = {
    manager = openstack_networking_secgroup_v2.osswarm-manager.id
    worker = openstack_networking_secgroup_v2.osswarm-worker.id
  }
}

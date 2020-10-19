resource "openstack_networking_secgroup_v2" "osswarm-manager" {
  name                 = "osswarm-${var.cluster}-manager"
  description          = "Docker Swarm Manager Access"
  delete_default_rules = true
}

resource "openstack_networking_secgroup_v2" "osswarm-worker" {
  name                 = "osswarm-${var.cluster}-worker"
  description          = "Docker Swarm Worker Access"
  delete_default_rules = true
}

module "manager-to-worker" {
  source = "./swarm"

  from = openstack_networking_secgroup_v2.osswarm-manager.id
  to   = openstack_networking_secgroup_v2.osswarm-worker.id
}

module "worker-to-manager" {
  source = "./swarm"

  from = openstack_networking_secgroup_v2.osswarm-worker.id
  to   = openstack_networking_secgroup_v2.osswarm-manager.id
}

output "swarm" {
  value = {
    manager = openstack_networking_secgroup_v2.osswarm-manager.id
    worker  = openstack_networking_secgroup_v2.osswarm-worker.id
  }
}

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

locals {
  manager = openstack_networking_secgroup_v2.osswarm-manager.id
  worker  = openstack_networking_secgroup_v2.osswarm-worker.id

  # We wouldn't want workers talking to other workers now, would we?!
  bidirectional = [
    { from = local.manager, to = local.manager },
    { from = local.manager, to = local.worker  },
    { from = local.worker,  to = local.manager },
  ]
}

module "swarm-rules" {
  # Even this is too much for Terraform's for_each!
  source = "./swarm"
  count  = 3

  from = local.bidirectional[count.index].from
  to   = local.bidirectional[count.index].to
}

output "swarm" {
  value = {
    manager = local.manager
    worker  = local.worker
  }
}

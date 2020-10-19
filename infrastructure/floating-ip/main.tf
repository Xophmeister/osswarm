locals {
  management = "management"
  service    = "service"
  role       = toset([local.management, local.service])
}

data "openstack_networking_network_v2" "external" {
  external = true
}

resource "openstack_networking_floatingip_v2" "ip" {
  for_each    = local.role
  pool        = data.openstack_networking_network_v2.external.name
  description = "osswarm-${var.cluster} ${each.value}"
}

resource "openstack_compute_floatingip_associate_v2" "management-ip" {
  floating_ip = openstack_networking_floatingip_v2.ip[local.management].address
  instance_id = var.manager
}

# resource "openstack_networking_floatingip_associate_v2" "service-ip" {
#   floating_ip = openstack_networking_floatingip_v2.ip[local.service].address
#   port_id     = var.load-balancer
# }

output "management" {
  value = openstack_networking_floatingip_v2.ip[local.management].address
}

# output "service" {
#   value = openstack_networking_floatingip_v2.ip[local.service].address
# }

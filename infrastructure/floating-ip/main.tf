data "openstack_networking_network_v2" "external" {
  external = true
}

resource "openstack_networking_floatingip_v2" "management-ip" {
  pool        = data.openstack_networking_network_v2.external.name
  description = "osswarm-${var.cluster} Management"
}

resource "openstack_compute_floatingip_associate_v2" "management-ip" {
  floating_ip = openstack_networking_floatingip_v2.management-ip.address
  instance_id = var.manager
}

resource "openstack_networking_floatingip_v2" "service-ip" {
  pool        = data.openstack_networking_network_v2.external.name
  description = "osswarm-${var.cluster} Services"
  port_id     = var.load-balancer
}

output "management" {
  value = openstack_networking_floatingip_v2.management-ip.address
}

output "service" {
  value = openstack_networking_floatingip_v2.service-ip.address
}

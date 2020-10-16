data "openstack_networking_network_v2" "external" {
  external = true
}

resource "openstack_networking_floatingip_v2" "ip" {
  pool        = data.openstack_networking_network_v2.external.name
  description = "osswarm-${var.cluster}"
}

resource "openstack_compute_floatingip_associate_v2" "public_ip" {
  floating_ip = openstack_networking_floatingip_v2.ip.address
  instance_id = var.instance
}

output "address" {
  value = openstack_networking_floatingip_v2.ip.address
}

data "openstack_networking_network_v2" "external" {
  external = true
}

## Management Floating IP

# If we're not fault tolerant, assign floating IP to an instance
resource "openstack_networking_floatingip_v2" "management-instance-ip" {
  count = var.fault-tolerant ? 0 : 1

  pool        = data.openstack_networking_network_v2.external.name
  description = "osswarm-${var.cluster} Management"
}

resource "openstack_compute_floatingip_associate_v2" "management-ip" {
  count = var.fault-tolerant ? 0 : 1

  floating_ip = openstack_networking_floatingip_v2.management-instance-ip[0].address
  instance_id = var.manager
}

# If we are fault tolerant, assign floating IP to a load balancer
resource "openstack_networking_floatingip_v2" "management-lb-ip" {
  count = var.fault-tolerant ? 1 : 0

  pool        = data.openstack_networking_network_v2.external.name
  description = "osswarm-${var.cluster} Management"
  port_id     = var.manager
}

## Service Floating IP
resource "openstack_networking_floatingip_v2" "service-ip" {
  pool        = data.openstack_networking_network_v2.external.name
  description = "osswarm-${var.cluster} Services"
  port_id     = var.services
}

output "management" {
  value = var.fault-tolerant ? openstack_networking_floatingip_v2.management-lb-ip[0].address : openstack_networking_floatingip_v2.management-instance-ip[0].address
}

output "service" {
  value = openstack_networking_floatingip_v2.service-ip.address
}

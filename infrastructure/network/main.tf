data "openstack_networking_network_v2" "external" {
  external = true
}

resource "openstack_networking_router_v2" "router" {
  name                = "osswarm-${var.cluster}-router"
  external_network_id = data.openstack_networking_network_v2.external.id
}

resource "openstack_networking_network_v2" "network" {
  name = "osswarm-${var.cluster}-network"
}

resource "openstack_networking_subnet_v2" "subnet" {
  name       = "osswarm-${var.cluster}-subnet"
  network_id = openstack_networking_network_v2.network.id
  cidr       = var.subnet
  ip_version = 4
}

resource "openstack_networking_router_interface_v2" "interface" {
  router_id = openstack_networking_router_v2.router.id
  subnet_id = openstack_networking_subnet_v2.subnet.id
}

output "id" {
  value = openstack_networking_network_v2.network.id
}

output "subnet" {
  value = openstack_networking_subnet_v2.subnet.id
}

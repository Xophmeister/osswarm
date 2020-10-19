resource "openstack_networking_secgroup_v2" "osswarm-services" {
  name                 = "osswarm-${var.cluster}-services"
  description          = "Container Access"
  delete_default_rules = true
}

resource "openstack_networking_secgroup_rule_v2" "osswarm-containers-in" {
  direction         = "ingress"
  ethertype         = "IPv4"
  description       = "Container access"
  protocol          = "tcp"
  port_range_min    = 8000
  port_range_max    = 8999
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.osswarm-services.id
}

output "services" {
  value = openstack_networking_secgroup_v2.osswarm-services.id
}

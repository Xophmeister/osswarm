resource "openstack_networking_secgroup_v2" "osswarm-netdata" {
  name                 = "osswarm-${var.cluster}-netdata"
  description          = "Netdata Access"
  delete_default_rules = true
}

resource "openstack_networking_secgroup_rule_v2" "osswarm-netdata-dashboard-in" {
  direction         = "ingress"
  ethertype         = "IPv4"
  description       = "Netdata dashboard access"
  protocol          = "tcp"
  port_range_min    = 19999
  port_range_max    = 19999
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.osswarm-netdata.id
}

output "netdata" {
  value = openstack_networking_secgroup_v2.osswarm-netdata.id
}

resource "openstack_networking_secgroup_v2" "osswarm-base" {
  name                 = "osswarm-${var.cluster}-base"
  description          = "Unfettered egress and ICMP"
  delete_default_rules = true
}

resource "openstack_networking_secgroup_rule_v2" "osswarm-base-egress-ipv4" {
  direction         = "egress"
  ethertype         = "IPv4"
  security_group_id = openstack_networking_secgroup_v2.osswarm-base.id
}

resource "openstack_networking_secgroup_rule_v2" "osswarm-base-egress-ipv6" {
  direction         = "egress"
  ethertype         = "IPv6"
  security_group_id = openstack_networking_secgroup_v2.osswarm-base.id
}

resource "openstack_networking_secgroup_rule_v2" "osswarm-base-icmp" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "icmp"
  security_group_id = openstack_networking_secgroup_v2.osswarm-base.id
}

output "base" {
  value = openstack_networking_secgroup_v2.osswarm-base.id
}

resource "openstack_networking_secgroup_v2" "osswarm-ssh" {
  name                 = "osswarm-${var.cluster}-ssh"
  description          = "SSH Access"
  delete_default_rules = true
}

resource "openstack_networking_secgroup_rule_v2" "osswarm-ssh-in" {
  direction         = "ingress"
  ethertype         = "IPv4"
  description       = "SSH access"
  protocol          = "tcp"
  port_range_min    = 22
  port_range_max    = 22
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.osswarm-ssh.id
}

output "ssh" {
  value = openstack_networking_secgroup_v2.osswarm-ssh.id
}

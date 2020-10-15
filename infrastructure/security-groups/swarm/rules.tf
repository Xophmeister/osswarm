/***********************************************************************
Open Protocols and Ports Between the Hosts[1]

The following ports must be available. On some systems, these ports are
open by default.

* TCP port 2377 for cluster management communications
* TCP and UDP port 7946 for communication among nodes
* UDP port 4789 for overlay network traffic

If you plan on creating an overlay network with encryption (--opt
encrypted), you also need to ensure ip protocol 50 (ESP) traffic is
allowed.

[1] https://docs.docker.com/engine/swarm/swarm-tutorial/#open-protocols-and-ports-between-the-hosts
***********************************************************************/

# Management Plane
resource "openstack_networking_secgroup_rule_v2" "osswarm-management-plane" {
  direction         = "ingress"
  ethertype         = "IPv4"
  description       = "Cluster management and Raft synchronisation"
  protocol          = "tcp"
  port_range_min    = 2377
  port_range_max    = 2377
  remote_group_id   = var.from
  security_group_id = var.to
}

# Control Plane
resource "openstack_networking_secgroup_rule_v2" "osswarm-control-plane" {
  direction         = "ingress"
  ethertype         = "IPv4"
  description       = "Control plane TCP"
  protocol          = "tcp"
  port_range_min    = 7946
  port_range_max    = 7946
  remote_group_id   = var.from
  security_group_id = var.to
}

# Data Plane (overlay VXLAN)
resource "openstack_networking_secgroup_rule_v2" "osswarm-data-plane" {
  direction         = "ingress"
  ethertype         = "IPv4"
  description       = "Data plane UDP"
  protocol          = "udp"
  port_range_min    = 4789
  port_range_max    = 4789
  remote_group_id   = var.from
  security_group_id = var.to
}

# Security Plane
resource "openstack_networking_secgroup_rule_v2" "osswarm-security-plane" {
  direction         = "ingress"
  ethertype         = "IPv4"
  description       = "Security plane ESP"
  protocol          = "esp"
  remote_group_id   = var.from
  security_group_id = var.to
}

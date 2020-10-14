# Open Protocols and Ports Between the Hosts[1]
#
# The following ports must be available. On some systems, these ports
# are open by default.
#
# * TCP port 2377 for cluster management communications
# * TCP and UDP port 7946 for communication among nodes
# * UDP port 4789 for overlay network traffic
#
# If you plan on creating an overlay network with encryption (--opt
# encrypted), you also need to ensure ip protocol 50 (ESP) traffic is
# allowed.
#
# [1] https://docs.docker.com/engine/swarm/swarm-tutorial/#open-protocols-and-ports-between-the-hosts

# FIXME? Are all these combinations of rules required for the Docker
# Swarm manager and workers? It seems to work without any "manager to
# worker" rules; maybe others can be removed, too...

resource "openstack_networking_secgroup_v2" "osswarm-manager" {
  name                  = "osswarm-${var.cluster}-manager"
  description           = "Docker Swarm Manager Access"
  delete_default_rules  = true
}

resource "openstack_networking_secgroup_v2" "osswarm-worker" {
  name                  = "osswarm-${var.cluster}-worker"
  description           = "Docker Swarm Worker Access"
  delete_default_rules  = true
}

resource "openstack_networking_secgroup_v2" "osswarm-ssh" {
  name                  = "osswarm-${var.cluster}-ssh"
  description           = "SSH Access"
  delete_default_rules  = true
}

resource "openstack_networking_secgroup_v2" "osswarm-netdata" {
  name                  = "osswarm-${var.cluster}-netdata"
  description           = "Netdata Access"
  delete_default_rules  = true
}

# Management plane

resource "openstack_networking_secgroup_rule_v2" "osswarm-m2m-in" {
  direction         = "ingress"
  ethertype         = "IPv4"
  description       = "Cluster management and Raft synchronisation (manager to manager)"
  protocol          = "tcp"
  port_range_min    = 2377
  port_range_max    = 2377
  remote_group_id   = openstack_networking_secgroup_v2.osswarm-manager.id
  security_group_id = openstack_networking_secgroup_v2.osswarm-manager.id
}

resource "openstack_networking_secgroup_rule_v2" "osswarm-w2m-in" {
  direction         = "ingress"
  ethertype         = "IPv4"
  description       = "Cluster management and Raft synchronisation (worker to manager)"
  protocol          = "tcp"
  port_range_min    = 2377
  port_range_max    = 2377
  remote_group_id   = openstack_networking_secgroup_v2.osswarm-worker.id
  security_group_id = openstack_networking_secgroup_v2.osswarm-manager.id
}

# Control plane

resource "openstack_networking_secgroup_rule_v2" "osswarm-m2m-control-tcp-in" {
  direction         = "ingress"
  ethertype         = "IPv4"
  description       = "Control plane TCP (manager to manager)"
  protocol          = "tcp"
  port_range_min    = 7946
  port_range_max    = 7946
  remote_group_id   = openstack_networking_secgroup_v2.osswarm-manager.id
  security_group_id = openstack_networking_secgroup_v2.osswarm-manager.id
}

resource "openstack_networking_secgroup_rule_v2" "osswarm-w2m-control-tcp-in" {
  direction         = "ingress"
  ethertype         = "IPv4"
  description       = "Control plane TCP (worker to manager)"
  protocol          = "tcp"
  port_range_min    = 7946
  port_range_max    = 7946
  remote_group_id   = openstack_networking_secgroup_v2.osswarm-worker.id
  security_group_id = openstack_networking_secgroup_v2.osswarm-manager.id
}

resource "openstack_networking_secgroup_rule_v2" "osswarm-w2w-control-tcp-in" {
  direction         = "ingress"
  ethertype         = "IPv4"
  description       = "Control plane TCP (worker to worker)"
  protocol          = "tcp"
  port_range_min    = 7946
  port_range_max    = 7946
  remote_group_id   = openstack_networking_secgroup_v2.osswarm-worker.id
  security_group_id = openstack_networking_secgroup_v2.osswarm-worker.id
}

resource "openstack_networking_secgroup_rule_v2" "osswarm-m2m-control-udp-in" {
  direction         = "ingress"
  ethertype         = "IPv4"
  description       = "Control plane UDP (manager to manager)"
  protocol          = "udp"
  port_range_min    = 7946
  port_range_max    = 7946
  remote_group_id   = openstack_networking_secgroup_v2.osswarm-manager.id
  security_group_id = openstack_networking_secgroup_v2.osswarm-manager.id
}

resource "openstack_networking_secgroup_rule_v2" "osswarm-w2m-control-udp-in" {
  direction         = "ingress"
  ethertype         = "IPv4"
  description       = "Control plane UDP (worker to manager)"
  protocol          = "udp"
  port_range_min    = 7946
  port_range_max    = 7946
  remote_group_id   = openstack_networking_secgroup_v2.osswarm-worker.id
  security_group_id = openstack_networking_secgroup_v2.osswarm-manager.id
}

resource "openstack_networking_secgroup_rule_v2" "osswarm-w2w-control-udp-in" {
  direction         = "ingress"
  ethertype         = "IPv4"
  description       = "Control plane UDP (worker to worker)"
  protocol          = "udp"
  port_range_min    = 7946
  port_range_max    = 7946
  remote_group_id   = openstack_networking_secgroup_v2.osswarm-worker.id
  security_group_id = openstack_networking_secgroup_v2.osswarm-worker.id
}

# Data plane (overlay VXLAN)

resource "openstack_networking_secgroup_rule_v2" "osswarm-m2m-data-udp-in" {
  direction         = "ingress"
  ethertype         = "IPv4"
  description       = "Data plane UDP (manager to manager)"
  protocol          = "udp"
  port_range_min    = 4789
  port_range_max    = 4789
  remote_group_id   = openstack_networking_secgroup_v2.osswarm-manager.id
  security_group_id = openstack_networking_secgroup_v2.osswarm-manager.id
}

resource "openstack_networking_secgroup_rule_v2" "osswarm-w2m-data-udp-in" {
  direction         = "ingress"
  ethertype         = "IPv4"
  description       = "Data plane UDP (worker to manager)"
  protocol          = "udp"
  port_range_min    = 4789
  port_range_max    = 4789
  remote_group_id   = openstack_networking_secgroup_v2.osswarm-worker.id
  security_group_id = openstack_networking_secgroup_v2.osswarm-manager.id
}

resource "openstack_networking_secgroup_rule_v2" "osswarm-w2w-data-udp-in" {
  direction         = "ingress"
  ethertype         = "IPv4"
  description       = "Data plane UDP (worker to worker)"
  protocol          = "udp"
  port_range_min    = 4789
  port_range_max    = 4789
  remote_group_id   = openstack_networking_secgroup_v2.osswarm-worker.id
  security_group_id = openstack_networking_secgroup_v2.osswarm-worker.id
}

# Security plane

resource "openstack_networking_secgroup_rule_v2" "osswarm-m2m-security-in" {
  direction         = "ingress"
  ethertype         = "IPv4"
  description       = "Security plane ESP (manager to manager)"
  protocol          = "esp"
  remote_group_id   = openstack_networking_secgroup_v2.osswarm-manager.id
  security_group_id = openstack_networking_secgroup_v2.osswarm-manager.id
}

resource "openstack_networking_secgroup_rule_v2" "osswarm-w2m-security-in" {
  direction         = "ingress"
  ethertype         = "IPv4"
  description       = "Security plane ESP (worker to manager)"
  protocol          = "esp"
  remote_group_id   = openstack_networking_secgroup_v2.osswarm-worker.id
  security_group_id = openstack_networking_secgroup_v2.osswarm-manager.id
}

resource "openstack_networking_secgroup_rule_v2" "osswarm-w2w-security-in" {
  direction         = "ingress"
  ethertype         = "IPv4"
  description       = "Security plane ESP (worker to worker)"
  protocol          = "esp"
  remote_group_id   = openstack_networking_secgroup_v2.osswarm-worker.id
  security_group_id = openstack_networking_secgroup_v2.osswarm-worker.id
}

# SSH

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

# Netdata

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

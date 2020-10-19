resource "openstack_lb_loadbalancer_v2" "load-balancer" {
  name               = "osswarm-${var.cluster}"
  vip_network_id     = var.network
  security_group_ids = var.security-groups
}

resource "openstack_lb_pool_v2" "pool" {
  loadbalancer_id = openstack_lb_loadbalancer_v2.load-balancer.id
  protocol        = "TCP"
  lb_method       = "ROUND_ROBIN"

  persistence {
    type = "SOURCE_IP"
  }
}

# FIXME
# * for_each cannot depend on resources that are yet to be determined;
#   to get around this, the deployment must be compartmentalised
# * A load balancer member can only listen on one port, rather than a
#   range... This needs more thought
resource "openstack_lb_member_v2" "member" {
  for_each = toset(var.nodes)

  pool_id       = openstack_lb_pool_v2.pool.id
  address       = each.value
  protocol_port = 8080
}

output "port" {
  value = openstack_lb_loadbalancer_v2.load-balancer.vip_port_id
}

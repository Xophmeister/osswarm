resource "openstack_lb_loadbalancer_v2" "load-balancer" {
  name           = "osswarm-${var.cluster}-${var.role}"
  vip_network_id = var.network
  vip_subnet_id  = var.subnet
}

resource "openstack_lb_listener_v2" "listener" {
  protocol        = "TCP"
  protocol_port   = var.listen-port
  loadbalancer_id = openstack_lb_loadbalancer_v2.load-balancer.id
}

resource "openstack_lb_pool_v2" "pool" {
  loadbalancer_id = openstack_lb_loadbalancer_v2.load-balancer.id
  protocol        = "TCP"
  lb_method       = "ROUND_ROBIN"

  persistence { type = "SOURCE_IP" }
}

resource "openstack_lb_member_v2" "member" {
  # Terraform's static analysis is not clever enough to realise that the
  # size of var.nodes is deterministic. As such, we can't use for_each
  # and instead have to help Terraform out with an explicit count
  count = var.node-count

  pool_id       = openstack_lb_pool_v2.pool.id
  address       = var.nodes[count.index]
  protocol_port = var.route-port
}

output "port" {
  value = openstack_lb_loadbalancer_v2.load-balancer.vip_port_id
}

data "openstack_compute_flavor_v2" "standard" {
  name = var.flavour
}

resource "openstack_compute_instance_v2" "instance" {
  name            = var.name
  flavor_id       = data.openstack_compute_flavor_v2.standard.flavor_id
  image_name      = var.image
  key_pair        = var.ssh-key
  security_groups = var.security-groups
  metadata        = var.metadata

  network { uuid = var.network }
  scheduler_hints { group = var.server-group }
}

output "id" {
  value = openstack_compute_instance_v2.instance.id
}

output "address" {
  value = openstack_compute_instance_v2.instance.access_ip_v4
}

data "openstack_compute_flavor_v2" "standard" {
  name = var.flavour
}

resource "openstack_compute_instance_v2" "instance" {
  name       = "osswarm-${var.cluster}-${var.role}-${format("%02d", count.index + 1)}"
  flavor_id  = data.openstack_compute_flavor_v2.standard.flavor_id
  image_name = var.image
  key_pair   = var.ssh-key

  network {
    uuid = var.network
  }
  security_groups = var.security-groups

  metadata = {
    role = var.role
  }

  count = var.tally
}

output "id" {
  value = openstack_compute_instance_v2.instance.*.id
}

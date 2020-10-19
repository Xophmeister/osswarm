provider local {}

data "local_file" "public_key" {
  filename = pathexpand(var.key)
}

resource "openstack_compute_keypair_v2" "public_key" {
  name       = "osswarm-${var.cluster}"
  public_key = chomp(data.local_file.public_key.content)
}

output "name" {
  value = openstack_compute_keypair_v2.public_key.name
}

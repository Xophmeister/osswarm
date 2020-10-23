resource "openstack_compute_keypair_v2" "public_key" {
  name       = "osswarm-${var.cluster}"
  public_key = chomp(file(pathexpand(var.key)))
}

output "name" {
  value = openstack_compute_keypair_v2.public_key.name
}

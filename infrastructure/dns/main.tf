provider infoblox {}

locals {
  role = {
    management = var.management
    # service    = var.service
  }
}

# FIXME
# * Why would an A record need a CIDR?
# * What's the difference between tenant_id and zone?
# * dns_view needs to be parametrised
resource "infoblox_a_record" "record" {
  for_each = local.role

  vm_name   = each.value.subdomain
  ip_addr   = each.value.address
  # cidr      = ???
  tenant_id = split(var.domain)[0]
  zone      = var.domain
  dns_view  = "internal"
}

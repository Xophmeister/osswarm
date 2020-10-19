provider local {}

data "local_file" "infoblox_config" {
  filename = pathexpand(var.config)
}

locals {
  config = yamldecode(data.local_file.infoblox_config.content)

  role = {
    management = var.management
    # service    = var.service
  }

  tenant = split(var.domain, ".")[0]
}

provider infoblox {
  server   = local.config["server"]
  username = local.config["username"]
  password = local.config["password"]
}

resource "infoblox_a_record" "record" {
  for_each = local.role

  tenant_id = local.tenant
  zone      = var.domain
  dns_view  = local.config["dns_view"]

  vm_name = each.value.subdomain
  ip_addr = each.value.address

  # NOTE The CIDR is required by the Terraform provider, but not used by
  # the Infoblox client when the IP address is specified.[1] As such, we
  # just set it to anything.
  # [1] https://github.com/infobloxopen/infoblox-go-client/blob/2995643c3c7a27db7fb9dc00dd5daf292f6731a6/object_manager.go#L520-L537
  cidr = "10.0.0.1/24"
}

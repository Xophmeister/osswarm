variable "domain" {
  type        = string
  description = "Domain under which to expose the cluster"
}

variable "management" {
  type        = object({ address = string, subdomain = string })
  description = "Management DNS configuration"
}

# variable "service" {
#   type        = object({ address = string, subdomain = string })
#   description = "Service DNS configuration"
# }

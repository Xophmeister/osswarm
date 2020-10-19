terraform {
  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "2.0.0"
    }
    infoblox = {
      source  = "terraform-providers/infoblox"
      version = "1.1.0"
    }
  }
  required_version = ">= 0.13"
}

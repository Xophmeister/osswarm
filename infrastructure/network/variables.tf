variable "cluster" {
  type        = string
  description = "Name for the cluster infrastructure"
}

variable "subnet" {
  type        = string
  description = "Subnet CIDR"
  default     = "10.1.0.0/24"
}

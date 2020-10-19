variable "cluster" {
  type        = string
  description = "Name for the cluster infrastructure"
}

variable "manager" {
  type        = string
  description = "Manager instance ID"
}

# TODO
variable "load-balancer" {
  type        = string
  description = "Load balancer port"
  default     = "TODO..."
}

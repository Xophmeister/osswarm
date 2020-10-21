variable "cluster" {
  type        = string
  description = "Name for the cluster infrastructure"
}

variable "manager" {
  type        = string
  description = "Manager instance ID"
}

variable "load-balancer" {
  type        = string
  description = "Load balancer port"
}

variable "cluster" {
  type        = string
  description = "Name for the cluster infrastructure"
}

variable "fault-tolerant" {
  type        = bool
  description = "Whether management is fault tolerant"
}

variable "manager" {
  type        = string
  description = "Manager load balancer port or instance ID"
}

variable "services" {
  type        = string
  description = "Services load balancer port"
}

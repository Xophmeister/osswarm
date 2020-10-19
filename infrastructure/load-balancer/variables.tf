variable "cluster" {
  type        = string
  description = "Name for the cluster infrastructure"
}

variable "network" {
  type        = string
  description = "Network to which to attach the load balancer"
}

variable "nodes" {
  type        = list(string)
  description = "Node IP addresses over which to balance"
}

variable "security-groups" {
  type        = list(string)
  description = "Load balancer security groups"
}

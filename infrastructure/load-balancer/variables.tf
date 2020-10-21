variable "cluster" {
  type        = string
  description = "Name for the cluster infrastructure"
}

variable "network" {
  type        = string
  description = "Network to which to attach the load balancer"
}

variable "subnet" {
  type        = string
  description = "Subnet to which to attach the load balancer"
}

variable "node-count" {
  type        = number
  description = "Number of nodes over which to balance"
}

variable "nodes" {
  type        = list(string)
  description = "Node IP addresses over which to balance"
}

variable "cluster" {
  type        = string
  description = "Name for the cluster infrastructure"
}

variable "role" {
  type        = string
  description = "Role for the load balancer"
}

variable "network" {
  type        = string
  description = "Network to which to attach the load balancer"
}

variable "subnet" {
  type        = string
  description = "Subnet to which to attach the load balancer"
}

variable "listen-port" {
  type        = number
  description = "Port on which to listen"
}

variable "route-port" {
  type        = number
  description = "Port to which to route"
}

variable "node-count" {
  type        = number
  description = "Number of nodes over which to balance"
}

variable "nodes" {
  type        = list(string)
  description = "Node IP addresses over which to balance"
}

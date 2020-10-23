variable "cluster" {
  type        = string
  description = "Name for the cluster infrastructure"
}

variable "image" {
  type        = string
  description = "Base image for compute nodes"
}

variable "flavour" {
  type        = string
  description = "Machine flavour for compute nodes"
}

variable "ssh-key" {
  type        = string
  description = "SSH key"
}

variable "network" {
  type        = string
  description = "Network to which to attach the compute nodes"
}

variable "managers" {
  type        = number
  description = "Number of manager nodes"
}

variable "workers" {
  type        = number
  description = "Number of worker nodes"
}

variable "security-groups" {
  type        = object({ manager = list(string), worker = list(string) })
  description = "Manager and worker node security groups"
}

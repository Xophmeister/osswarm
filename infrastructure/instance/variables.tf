variable "cluster" {}
variable "image" {}
variable "flavour" {}

variable "role" {
  type        = string
  description = "Docker Swarm role for the instance"

  validation {
    condition     = var.role == "manager" || var.role == "worker"
    error_message = "Role must be 'manager' or 'worker'."
  }
}

variable "ssh-key" {
  description = "SSH key"
}

variable "network" {
  description = "Network on to which to attach the instance"
}

variable "security-groups" {
  type        = list(string)
  description = "Security groups to which to assign the instance"
}

# We use this, instead of "count" where the module is instantiated, to
# keep the replication logic internalised
variable "tally" {
  type        = number
  default     = 1
  description = "Number of instances"
}

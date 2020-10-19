variable "image" {
  type        = string
  description = "Image for the instance"
}

variable "flavour" {
  type        = string
  description = "Machine flavour for the instance"
}

variable "name" {
  type        = string
  description = "Name of the instance"
}

variable "server-group" {
  type        = string
  description = "Server group to associate with the instance"
}

variable "ssh-key" {
  type        = string
  description = "SSH key"
}

variable "network" {
  type        = string
  description = "Network to which to attach the instance"
}

variable "metadata" {
  type        = map(any)
  description = "Metadata to associate with the instance"
}

variable "security-groups" {
  type        = list(string)
  description = "Security groups to which to assign the instance"
}

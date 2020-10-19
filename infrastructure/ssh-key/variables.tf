variable "cluster" {
  type        = string
  description = "Name for the cluster infrastructure"
}

variable "key" {
  type        = string
  description = "Path to a public key file, for which its private key must exist"
}

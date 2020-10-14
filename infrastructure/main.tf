variable "cluster" {
  description = "Name for the cluster infrastructure"
}

module "security-groups" {
  source = "./security-groups"

  cloud = var.cloud
  cluster = var.cluster
}

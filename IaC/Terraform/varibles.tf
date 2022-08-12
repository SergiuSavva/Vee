variable "aws_region" {
  default = "us-east-1"
}

variable "vpc_name" {}

variable "eks_cluster_name" {}

variable "eks_node_groups" {
  type = map(map(string))
}

variable "efs_name" {}

variable "kubernetes_version" {
  default = "1.23"
}

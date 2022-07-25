variable "aws_region" {
  default = "us-east-1"
}

variable "vpc_name" {}

variable "eks_cluster_name" {}

variable "eks_node_groups" {
  type = map(map(string))
}

variable "efs_name" {}

variable "mysql" {
  type            = object({
    rootPassword  = string
    username      = string
    password      = string
    size          = string
    initdbScripts = list(string)
  })
}

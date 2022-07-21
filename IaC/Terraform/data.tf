data "aws_availability_zones" "current" {
  state = "available"
}

data "aws_eks_cluster" "default" {
  name = var.eks_cluster_name
}

data "aws_eks_cluster_auth" "default" {
  name = var.eks_cluster_name
}

data "tls_certificate" "eks_cluster" {
  url = aws_eks_cluster.default.identity[0].oidc[0].issuer
}

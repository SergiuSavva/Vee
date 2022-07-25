data "aws_region" "current" {}

data "aws_availability_zones" "current" {
  state = "available"
}

data "aws_eks_cluster" "default" {
  name       = var.eks_cluster_name
  depends_on = [aws_eks_cluster.default]
}

data "aws_eks_cluster_auth" "default" {
  name       = var.eks_cluster_name
  depends_on = [aws_eks_cluster.default]
}

data "tls_certificate" "eks_cluster" {
  url = aws_eks_cluster.default.identity[0].oidc[0].issuer
}

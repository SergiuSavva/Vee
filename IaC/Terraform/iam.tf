data "aws_iam_policy_document" "eks_cluster_trust_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["eks.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "eks_node_trust_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

data "aws_iam_policy" "eks_cluster_policy" {
  name = "AmazonEKSClusterPolicy"
}

data "aws_iam_policy" "eks_node_policy" {
  name = "AmazonEKSWorkerNodePolicy"
}

data "aws_iam_policy" "eks_ecr_policy" {
  name = "AmazonEC2ContainerRegistryReadOnly"
}

data "aws_iam_policy" "eks_cni_policy" {
  name = "AmazonEKS_CNI_Policy"
}

data "aws_iam_policy" "eks_csi_policy" {
  name = "AmazonEBSCSIDriverPolicy"
}

resource "aws_iam_role" "eks_cluster_role" {
  name               = "EKSClusterRole"
  description        = "Amazon EKS - Cluster role"
  assume_role_policy = data.aws_iam_policy_document.eks_cluster_trust_policy.json
}

resource "aws_iam_role_policy_attachment" "eks_cluster_role_attachment" {
  role       = aws_iam_role.eks_cluster_role.name
  policy_arn = data.aws_iam_policy.eks_cluster_policy.arn
}

resource "aws_iam_role" "eks_node_role" {
  name               = "EKSNodeRole"
  description        = "Amazon EKS - Node role"
  assume_role_policy = data.aws_iam_policy_document.eks_node_trust_policy.json
}

resource "aws_iam_role_policy_attachment" "eks_node_role_attachment1" {
  role       = aws_iam_role.eks_node_role.name
  policy_arn = data.aws_iam_policy.eks_node_policy.arn
}

resource "aws_iam_role_policy_attachment" "eks_node_role_attachment2" {
  role       = aws_iam_role.eks_node_role.name
  policy_arn = data.aws_iam_policy.eks_ecr_policy.arn
}

resource "aws_iam_role_policy_attachment" "eks_node_role_attachment3" {
  role       = aws_iam_role.eks_node_role.name
  policy_arn = data.aws_iam_policy.eks_cni_policy.arn
}

resource "aws_iam_role_policy_attachment" "eks_node_role_attachment4" {
  role       = aws_iam_role.eks_node_role.name
  policy_arn = data.aws_iam_policy.eks_csi_policy.arn
}

resource "aws_iam_openid_connect_provider" "eks_cluster" {
  client_id_list = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.eks_cluster.certificates[0].sha1_fingerprint]
  url             = aws_eks_cluster.default.identity[0].oidc[0].issuer
}

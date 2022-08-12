resource "helm_release" "cluster-autoscaler" {
  name             = "cluster-autoscaler"
  namespace        = "kube-system"
  repository       = "https://kubernetes.github.io/autoscaler"
  chart            = "cluster-autoscaler"
  version          = "9.19.2"
  atomic           = true

  values = [
    templatefile("${path.module}/helm-values/cluster-autoscaler.yaml", {
        role_arn     = aws_iam_role.EKS_Cluster_Autoscaler_Role.arn
        cluster_name = var.eks_cluster_name
      }
    )
  ]
}

data "aws_iam_policy_document" "cluster_autoscaler" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    condition {
      test     = "StringEquals"
      variable = "${replace(aws_iam_openid_connect_provider.eks_cluster.url, "https://", "")}:sub"
      values   = ["system:serviceaccount:kube-system:cluster-autoscaler"]
    }

    condition {
      test     = "StringEquals"
      variable = "${replace(aws_iam_openid_connect_provider.eks_cluster.url, "https://", "")}:aud"
      values   = ["sts.amazonaws.com"]
    }

    principals {
      identifiers = [aws_iam_openid_connect_provider.eks_cluster.arn]
      type        = "Federated"
    }
  }
}

resource "aws_iam_policy" "EKS_Cluster_Autoscaler_Policy" {
  name   = "EKS_Cluster_Autoscaler_Policy"
  policy = file("${path.module}/policies/cluster_autoscaler.json")
}

resource "aws_iam_role" "EKS_Cluster_Autoscaler_Role" {
  assume_role_policy = data.aws_iam_policy_document.cluster_autoscaler.json
  name               = "EKS_Cluster_Autoscaler_Role"
}

resource "aws_iam_role_policy_attachment" "cluster_autoscaler_role_attachment" {
  role       = aws_iam_role.EKS_Cluster_Autoscaler_Role.name
  policy_arn = aws_iam_policy.EKS_Cluster_Autoscaler_Policy.arn
}

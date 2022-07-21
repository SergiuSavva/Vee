resource "helm_release" "aws-load-balancer-controller" {
  name             = "aws-load-balancer-controller"
  namespace        = "kube-system"
  chart            = "aws-load-balancer-controller"
  repository       = "https://aws.github.io/eks-charts"
  version          = "1.4.2"
  atomic           = true
  create_namespace = true

  values = [
    templatefile("${path.module}/helm-values/aws-load-balancer-controller.yaml", {
      cluster_name = var.eks_cluster_name,
      role_arn     = aws_iam_role.EKSLoadBalancerControllerRole.arn,
    })
  ]
}

data "aws_iam_policy_document" "aws_alb_ingress_trust_policy" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    condition {
      test     = "StringEquals"
      variable = "${replace(aws_iam_openid_connect_provider.eks_cluster.url, "https://", "")}:sub"
      values   = ["system:serviceaccount:kube-system:aws-load-balancer-controller"]
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

resource "aws_iam_policy" "EKSLoadBalancerController" {
  name   = "EKSLoadBalancerController"
  policy = file("${path.module}/policies/alb_ingress_controller_policy.json")
}

resource "aws_iam_role" "EKSLoadBalancerControllerRole" {
  assume_role_policy = data.aws_iam_policy_document.aws_alb_ingress_trust_policy.json
  name               = "EKSLoadBalancerControllerRole"
}

resource "aws_iam_role_policy_attachment" "ingress_role_attachment" {
  role       = aws_iam_role.EKSLoadBalancerControllerRole.name
  policy_arn = aws_iam_policy.EKSLoadBalancerController.arn
}

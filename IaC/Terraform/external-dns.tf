resource "helm_release" "external-dns" {
  name             = "external-dns"
  namespace        = "kube-system"
  repository       = "https://kubernetes-sigs.github.io/external-dns"
  chart            = "external-dns"
  version          = "1.10.1"
  atomic           = true
  create_namespace = true

  values = [
    templatefile("${path.module}/helm-values/external-dns.yaml", {
        role_arn = aws_iam_role.EKS_ExternalDNS_Role.arn
      }
    )
  ]
}

data "aws_iam_policy_document" "external_dns_trust_policy" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    condition {
      test     = "StringEquals"
      variable = "${replace(aws_iam_openid_connect_provider.eks_cluster.url, "https://", "")}:sub"
      values   = ["system:serviceaccount:kube-system:external-dns"]
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

resource "aws_iam_policy" "EKS_ExternalDNS_Policy" {
  name   = "EKS_ExternalDNS_Policy"
  policy = file("${path.module}/policies/external_dns_policy.json")
}

resource "aws_iam_role" "EKS_ExternalDNS_Role" {
  assume_role_policy = data.aws_iam_policy_document.external_dns_trust_policy.json
  name               = "EKS_ExternalDNS_Role"
}

resource "aws_iam_role_policy_attachment" "external_dns_role_attachment" {
  role       = aws_iam_role.EKS_ExternalDNS_Role.name
  policy_arn = aws_iam_policy.EKS_ExternalDNS_Policy.arn
}

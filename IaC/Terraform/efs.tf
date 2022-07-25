resource "aws_efs_file_system" "default" {
  creation_token = var.efs_name
  encrypted      = true
}

resource "aws_efs_mount_target" "default" {
  for_each        = toset(module.vpc.private_subnets)
  file_system_id  = aws_efs_file_system.default.id
  subnet_id       = each.key
  security_groups = [aws_security_group.allow_nfs.id]
}

resource "helm_release" "aws-efs-csi-driver" {
  name             = "aws-efs-csi-driver"
  namespace        = "kube-system"
  chart            = "aws-efs-csi-driver"
  repository       = "https://kubernetes-sigs.github.io/aws-efs-csi-driver"
  version          = "2.2.7"
  atomic           = true
  create_namespace = true

  values = [
    templatefile("${path.module}/helm-values/aws-efs-csi-driver-values.yaml", {
      role_arn = aws_iam_role.EKS_EFS_CSI_DriverRole.arn,
      region   = data.aws_region.current.name
    })
  ]
}

resource "kubernetes_storage_class" "efs" {
  metadata {
    name = "efs"
  }
  storage_provisioner    = "efs.csi.aws.com"
  reclaim_policy         = "Delete"
  allow_volume_expansion = true
  parameters             = {
    provisioningMode     = "efs-ap"
    fileSystemId         = aws_efs_file_system.default.id
    directoryPerms       = "700"
  }
}

data "aws_iam_policy_document" "efs_csi_driver_trust_policy" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    condition {
      test     = "StringEquals"
      variable = "${replace(aws_iam_openid_connect_provider.eks_cluster.url, "https://", "")}:sub"
      values   = ["system:serviceaccount:kube-system:efs-csi-controller-sa"]
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

resource "aws_iam_policy" "EKS_EFS_CSI_Driver_Policy" {
  name   = "EKS_EFS_CSI_Driver_Policy"
  policy = file("${path.module}/policies/efs_csi_policy.json")
}

resource "aws_iam_role" "EKS_EFS_CSI_DriverRole" {
  name               = "EKS_EFS_CSI_DriverRole"
  assume_role_policy = data.aws_iam_policy_document.efs_csi_driver_trust_policy.json
}

resource "aws_iam_role_policy_attachment" "efs_csi_role_attachment" {
  role       = aws_iam_role.EKS_EFS_CSI_DriverRole.name
  policy_arn = aws_iam_policy.EKS_EFS_CSI_Driver_Policy.arn
}

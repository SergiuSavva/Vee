resource "aws_eks_cluster" "default" {
  name     = var.eks_cluster_name
  role_arn = aws_iam_role.eks_cluster_role.arn
  version  = var.kubernetes_version

  vpc_config {
    subnet_ids              = concat(module.vpc.private_subnets, module.vpc.public_subnets)
    endpoint_private_access = true
    endpoint_public_access  = true
  }

  depends_on = [
    module.vpc,
    aws_iam_role.eks_cluster_role,
  ]
}

resource "aws_eks_node_group" "default" {
  for_each        = var.eks_node_groups
  cluster_name    = aws_eks_cluster.default.name
  version         = var.kubernetes_version
  node_group_name = each.key
  node_role_arn   = aws_iam_role.eks_node_role.arn
  subnet_ids      = module.vpc.private_subnets
  instance_types  = [each.value.instance_type]
  disk_size       = each.value.disk_size_gb

  scaling_config {
    desired_size = each.value.num_instances
    max_size     = each.value.max_instances
    min_size     = each.value.num_instances
  }

  lifecycle {
    ignore_changes = [scaling_config[0].desired_size]
  }

  update_config {
    max_unavailable = 1
  }

  depends_on = [
    module.vpc,
    aws_iam_role.eks_node_role,
  ]
}

resource "aws_eks_addon" "aws-ebs-csi-driver" {
  cluster_name      = aws_eks_cluster.default.name
  addon_name        = "aws-ebs-csi-driver"
  resolve_conflicts = "OVERWRITE"
}

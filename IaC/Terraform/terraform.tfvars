aws_region       = "us-east-1"
vpc_name         = "veeVPC"
efs_name         = "veeEFS"
eks_cluster_name = "veeEKS"
eks_node_groups  = {
  small = {
    instance_type = "t3.small"
    num_instances = 1
    max_instances = 2
    disk_size_gb  = 20
  },
  large           = {
    instance_type = "t3.medium"
    num_instances = 1
    max_instances = 2
    disk_size_gb  = 20
  }
}

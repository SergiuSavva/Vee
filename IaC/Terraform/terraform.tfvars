aws_region       = "us-east-1"
vpc_name         = "testVPC"
eks_cluster_name = "testEKS"
eks_node_groups = {
  small = {
    instance_type = "t3.small"
    num_instances = 1
    disk_size_gb  = 20
  },
  large = {
    instance_type = "t3.medium"
    num_instances = 1
    disk_size_gb  = 20
  }
}

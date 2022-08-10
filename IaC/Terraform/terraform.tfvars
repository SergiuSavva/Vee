aws_region       = "us-east-1"
vpc_name         = "testVPC"
efs_name         = "testEFS"
eks_cluster_name = "testEKS"
eks_node_groups  = {
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
mysql           = {
  rootPassword  = "mysqlrootpass"
  username      = "lrvl_user"
  password      = "mysqlpass"
  size          = "8Gi"
  initdbScripts = [
    "scripts/db_init.sql",
    "scripts/wp_init.sql.gz",
  ]
}

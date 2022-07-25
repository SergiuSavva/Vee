This Terraform code deploys the following items in AWS:
- VPC (3 public and 3 private subnets)
- EKS cluster (node groups in private subnets)
- EFS filesystem and corresponding [Kubernetes EFS provisioner](https://docs.aws.amazon.com/eks/latest/userguide/efs-csi.html)
- [ALB Ingress Controller](https://docs.aws.amazon.com/eks/latest/userguide/aws-load-balancer-controller.html)
- [ExternalDNS](https://aws.amazon.com/premiumsupport/knowledge-center/eks-set-up-externaldns) addon

All the software is deployed to EKS using Helm charts.

All the supporting services (ALB Ingress, EFS provisioner, ExternalDNS) are using [IAM Roles for Service Accounts](https://docs.aws.amazon.com/eks/latest/userguide/iam-roles-for-service-accounts.html)

The code expects the following variables to be defined (either via `terraform.tfvars` or via command line):
```
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
    "scripts/wp_init.sql",
  ]
}
```

In order to deploy the TF code first you need to run below command to create the VPC:
```
terraform apply -target module.vpc
```
After the VPC is created you can create everything else by running:
```
terraform apply
```
You can destroy the environment using command:
```
terraform destroy
```

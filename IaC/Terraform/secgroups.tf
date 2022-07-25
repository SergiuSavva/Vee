resource "aws_security_group" "allow_nfs" {
  name        = "allow_NFS"
  description = "Allow NFS traffic"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description      = "NFS VPC-internal"
    from_port        = 2049
    to_port          = 2049
    protocol         = "tcp"
    cidr_blocks      = [module.vpc.vpc_cidr_block]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

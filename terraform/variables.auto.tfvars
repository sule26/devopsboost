# VPC
vpc_name        = "tcc-vpc"
cidr            = "10.0.0.0/16"
azs             = ["us-east-1a", "us-east-1b", "us-east-1c", "us-east-1d", "us-east-1f"]
public_subnets  = ["10.0.0.0/21", "10.0.8.0/21", "10.0.16.0/21", "10.0.24.0/21", "10.0.32.0/21"]
private_subnets = ["10.0.40.0/21", "10.0.48.0/21", "10.0.56.0/21", "10.0.64.0/21", "10.0.72.0/21"]

#S3
bucket_name          = "tcc-uerj-tfstate"
enable_force_destroy = true
versioning           = "Enabled"
versioning_lifecycle = "Enabled"
stored_version       = 5

# EKS
cluster_name      = "tcc-eks"
cluster_version   = "1.31"
service_ipv4_cidr = "10.100.0.0/16"
ami               = "AL2_x86_64"
ami_graviton      = "AL2_ARM_64"
disk_size         = 100

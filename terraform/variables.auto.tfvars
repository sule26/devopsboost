project_name = "UERJ - Bootstrap"

# VPC
vpc_name             = "uerj-vpc"
vpc_cidr             = "10.0.0.0/16"
public_subnets_cidr  = ["10.0.0.0/21", "10.0.8.0/21", "10.0.16.0/21", "10.0.24.0/21", "10.0.32.0/21", "10.0.40.0/21"]
private_subnets_cidr = ["10.0.48.0/21", "10.0.56.0/21", "10.0.64.0/21", "10.0.72.0/21", "10.0.80.0/21", "10.0.88.0/21"]

#S3
bucket_name          = "tcc-uerj-tfstate"
enable_force_destroy = true
versioning           = "Enabled"
versioning_lifecycle = "Enabled"
stored_version       = 3


# EKS
cluster_name      = "main-eks"
cluster_version   = "1.31"
service_ipv4_cidr = "10.100.0.0/16"

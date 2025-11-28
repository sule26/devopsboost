# VPC
vpc_name        = "uerj"
cidr            = "10.0.0.0/16"
azs             = ["us-east-1a", "us-east-1b", "us-east-1c", "us-east-1d", "us-east-1f"]
public_subnets  = ["10.0.0.0/21", "10.0.8.0/21", "10.0.16.0/21", "10.0.24.0/21", "10.0.32.0/21"]
private_subnets = ["10.0.40.0/21", "10.0.48.0/21", "10.0.56.0/21", "10.0.64.0/21", "10.0.72.0/21"]

#S3
# buckets_name          = ["uerj-devops-loki", "uerj-devops-velero"]
buckets_name = {
  loki = "uerj-devops-loki"
  velero = "uerj-devops-velero"
}
enable_force_destroy = true

# EKS
cluster_name      = "uerj-devops"
cluster_version   = "1.34"
service_ipv4_cidr = "10.100.0.0/16"
ami               = "BOTTLEROCKET_x86_64"
ami_graviton      = "BOTTLEROCKET_ARM_64"
disk_size         = 100

# RDS
db_allocated_storage = 20
db_identifier        = "eks-postgres"
db_engine            = "postgres"
db_engine_version    = "16.8"
db_instance_class    = "db.t3.micro"
db_username          = "postgres"


# IAM
aws_ebs_csi_driver_role = "AWSEBSCSIDriverAccessRole"
loki_role             = "LokiAccessRole"
loki_policy           = "LokiAccessPolicy"
velero_role           = "VeleroAccessRole"
velero_policy         = "VeleroAccessPolicy"
cert_manager_role     = "CertManagerAccessRole"
cert_manager_policy   = "CertManagerAccessPolicy"
crossplane_role       = "CrossplaneAccessRole"
crossplane_policy     = "CrossplaneAccessPolicy"
external_secret_role  = "ExternalSecretAccessRole"
external_secret_policy= "ExternalSecretAccessPolicy"
external_dns_role     = "ExternalDNSAccessRole"
external_dns_policy   = "ExternalDNSAccessPolicy"

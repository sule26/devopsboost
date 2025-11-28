variable "region" {
  description = "AWS Region"
  type        = string
  default     = "us-east-1"
}

# VPC
variable "vpc_name" {
  description = "Name of the VPC"
  type        = string
}

variable "cidr" {
  description = "Cidr of the VPC"
  type        = string
}

variable "azs" {
  description = "List of subnets"
  type        = list(string)
}

variable "private_subnets" {
  description = "Cidr for private subnets"
  type        = list(string)
}

variable "public_subnets" {
  description = "Cidr for public subnets"
  type        = list(string)
}

# S3
variable "buckets_name" {
  description = "Name of the bucket"
  type        = map(string)
}

variable "enable_force_destroy" {
  description = "Enable all objects to be deleted from the bucket when the bucket is destroyed"
  type        = bool
  default     = false
}

# EKS
variable "cluster_version" {
  type    = string
  default = "1.34"
}

variable "cluster_name" {
  type = string
}

variable "cluster_policies_arn" {
  type    = list(string)
  default = ["arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"]
}

variable "node_policies_arn" {
  type    = list(string)
  default = ["arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy", "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy", "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy", "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly", "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"]
}

variable "karpenter_node_policies_arn" {
  # type = list(string)
  default = ["arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy", "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy", "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"]
}

variable "ami" {
  type    = string
  default = "BOTTLEROCKET_x86_64"
}

variable "ami_graviton" {
  type    = string
  default = "BOTTLEROCKET_ARM_64"
}

variable "disk_size" {
  type    = number
  default = 100
}

variable "service_ipv4_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "karpenter_namespace" {
  type    = string
  default = "kube-system"
}

## IAM

variable "aws_ebs_csi_driver_role" {
  type    = string
  default = "LokiAccessRole"
}

variable "loki_role" {
  type    = string
  default = "LokiAccessRole"
}

variable "loki_policy" {
  type    = string
  default = "LokiAccessPolicy"
}

variable "velero_role" {
  type    = string
  default = "VeleroAccessRole"
}

variable "velero_policy" {
  type    = string
  default = "VeleroAccessPolicy"
}

variable "cert_manager_role" {
  type    = string
  default = "CertManagerAccessRole"
}

variable "cert_manager_policy" {
  type    = string
  default = "CertManagerAccessPolicy"
}

variable "crossplane_role" {
  type    = string
  default = "CrossplaneAccessRole"
}

variable "crossplane_policy" {
  type    = string
  default = "CrossplaneAccessPolicy"
}

variable "external_secret_role" {
  type    = string
  default = "ExternalSecretAccessRole"
}

variable "external_secret_policy" {
  type    = string
  default = "ExternalSecretAccessPolicy"
}

variable "external_dns_role" {
  type    = string
  default = "ExternalDNSAccessRole"
}

variable "external_dns_policy" {
  type    = string
  default = "ExternalDNSAccessPolicy"
}

# RDS
variable "db_allocated_storage" {
  type    = number
  default = 20
}

variable "db_identifier" {
  type    = string
  default = "eks-postgres"
}

variable "db_engine" {
  type    = string
  default = "postgresql"
}

variable "db_engine_version" {
  type    = string
  default = "16.8"
}

variable "db_instance_class" {
  type    = string
  default = "db.t3.micro"
}

variable "db_username" {
  type    = string
  default = "postgres"
}

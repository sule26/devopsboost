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
variable "bucket_name" {
  description = "Name of the bucket"
  type        = string
}

variable "enable_force_destroy" {
  description = "Enable all objects to be deleted from the bucket when the bucket is destroyed"
  type        = bool
  default     = false
}

variable "versioning" {
  description = "Enable versioning"
  type        = string
  default     = "Disable"
  validation {
    condition     = contains(["Enabled", "Suspended", "Disabled"], var.versioning)
    error_message = "Valid values for versioning: (Enabled, Suspended, Disabled)"
  }
}

variable "versioning_lifecycle" {
  description = "Enable versioning lifecycle"
  type        = string
  default     = "Disable"
  validation {
    condition     = contains(["Enabled", "Disabled"], var.versioning_lifecycle)
    error_message = "Valid values for versioning_lifecycle: (Enabled, Disabled)"
  }
}

variable "stored_version" {
  description = "Number of versions to be stored"
  type        = number
  default     = 5
}

# EKS
variable "cluster_version" {
  type    = string
  default = "1.31"
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
  type    = list(string)
  default = ["arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy", "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy", "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly", "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore", "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"]
}

variable "ami" {
  type    = string
  default = "AL2_x86_64"
}

variable "ami_graviton" {
  type    = string
  default = "AL2_ARM_64"
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

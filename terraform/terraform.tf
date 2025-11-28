terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.80.0"
    }
    # kubernetes = {
    #   source  = "hashicorp/kubernetes"
    #   version = "2.20"
    # }
  }

}
provider "aws" {
  region  = "us-east-1"
  profile = "bdc-test"
  default_tags {
    tags = {
      Terraform = true
    }
  }
}

# data "aws_eks_cluster_auth" "eks" {
#   name = aws_eks_cluster.eks.name
# }

# provider "kubernetes" {
#   host                   = aws_eks_cluster.eks.endpoint
#   cluster_ca_certificate = base64decode(aws_eks_cluster.eks.certificate_authority[0].data)

#   exec {
#     api_version = "client.authentication.k8s.io/v1beta1"
#     command     = "aws"
#     args = [
#       "eks",
#       "get-token",
#       "--cluster-name",
#       aws_eks_cluster.eks.name,
#       "--region",
#       "us-east-1",
#       "--profile",
#       "bdc-test"
#     ]
#   }
# }

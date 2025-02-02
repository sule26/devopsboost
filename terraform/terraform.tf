terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.80.0"
    }
  }
  # backend "s3" {
  #   bucket = "bootstrap-test-tcc"
  #   key    = "vpc/main-eks"
  #   region = "us-east-1"
  # }
}
provider "aws" {
  region = "us-east-1"
  default_tags {
    tags = {
      Project   = "TCC-UERJ"
      Scope     = "Infra"
      Terraform = true
    }
  }
}


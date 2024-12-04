module "aws" {
  source       = "./aws"
  groups       = var.groups
  policies_aws = var.policies_aws
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}
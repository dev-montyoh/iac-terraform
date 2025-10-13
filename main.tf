/*
* 기본 Provider 설정
*/
terraform {
  required_providers {
    # Amazon Web Services
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }

    # Cloudflare
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 5"
    }
  }

  required_version = ">= 1.2.0"
}

# AWS
provider "aws" {
  region     = "ap-northeast-2"
  access_key = var.AWS_ACCESS_KEY_ID
  secret_key = var.AWS_SECRET_ACCESS_KEY
}

module "aws" {
  source                  = "./aws"
  groups                  = var.groups
  policies_aws            = var.policies_aws
  policies_custom         = var.policies_custom
  users                   = var.users
  VPC_ID                  = var.VPC_ID
  BUDGETS_ALARM_TARGETS   = var.BUDGETS_ALARM_TARGETS
  AWS_EC2_SSH_ALLOWED_IPS = var.AWS_EC2_SSH_ALLOWED_IPS
  AWS_EC2_SSH_PUBLIC_KEY  = var.AWS_EC2_SSH_PUBLIC_KEY
}

# CloudFlare
provider "cloudflare" {
  api_token = var.CLOUDFLARE_API_KEY
}

module "cloudflare" {
  source = "./cloudflare"
}
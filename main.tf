terraform {
  required_providers {
    # Amazon Web Services
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "5.11.0"
    }
  }
}

# AWS
provider "aws" {
  region     = "ap-northeast-2"
  access_key = var.AWS_ACCESS_KEY_ID
  secret_key = var.AWS_SECRET_ACCESS_KEY
}

provider "cloudflare" {
  email     = var.CLOUDFLARE_EMAIL
  api_token = var.CLOUDFLARE_API_TOKEN
}

module "aws" {
  source                      = "./aws"
  groups                      = var.groups
  policies_aws                = var.policies_aws
  policies_custom             = var.policies_custom
  users                       = var.users
  VPC_ID                      = var.VPC_ID
  BUDGETS_ALARM_TARGETS       = var.BUDGETS_ALARM_TARGETS
  AWS_EC2_SSH_ALLOWED_IPS     = var.AWS_EC2_SSH_ALLOWED_IPS
  AWS_SSH_PUBLIC_KEY          = var.AWS_EC2_SSH_PUBLIC_KEY
  AWS_EC2_USERDATA_GHCR_TOKEN = var.AWS_EC2_USERDATA_GHCR_TOKEN
}

module "cloudflare" {
  source                   = "./cloudflare"
  service_server_public_ip = module.aws.service_server_public_ip
  depends_on               = [module.aws]
  CLOUDFLARE_ZONE_ID       = var.CLOUDFLARE_ZONE_ID
  CLOUDFLARE_ACCOUNT_ID    = var.CLOUDFLARE_ACCOUNT_ID
}

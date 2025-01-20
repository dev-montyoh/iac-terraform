/*
* AWS 기본 설정
* **.auto.tfvars 값 전달
*/
module "aws" {
  source                = "./aws"
  groups                = var.groups
  policies_aws          = var.policies_aws
  policies_custom       = var.policies_custom
  users                 = var.users
  AWS_ACCESS_KEY_ID     = var.AWS_ACCESS_KEY_ID
  AWS_SECRET_ACCESS_KEY = var.AWS_SECRET_ACCESS_KEY
  VPC_ID                = var.VPC_ID
  BUDGETS_ALARM_TARGETS = var.BUDGETS_ALARM_TARGETS
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
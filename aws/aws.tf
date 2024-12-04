provider "aws" {
  region = "ap-northeast-2"
}

module "iam" {
  source       = "./iam"
  groups       = var.groups
  policies_aws = var.policies_aws
}
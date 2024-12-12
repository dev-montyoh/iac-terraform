provider "aws" {
  region     = "ap-northeast-2"
  access_key = var.AWS_ACCESS_KEY_ID
  secret_key = var.AWS_SECRET_ACCESS_KEY
}

module "iam" {
  source       = "./iam"
  groups       = var.groups
  policies_aws = var.policies_aws
  users        = var.users
}

module "ec2" {
  source = "./ec2"
  VPC_ID = var.VPC_ID
}
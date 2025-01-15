provider "aws" {
  region     = "ap-northeast-2"
  access_key = var.AWS_ACCESS_KEY_ID
  secret_key = var.AWS_SECRET_ACCESS_KEY
}

module "iam" {
  source          = "./iam"
  groups          = var.groups
  policies_aws    = var.policies_aws
  policies_custom = var.policies_custom
  users           = var.users
}

module "ec2" {
  source = "./ec2"
  VPC_ID = var.VPC_ID
}

module "ssm" {
  source = "./ssm"
  role_name = module.iam.role_ssm_ec2.name
  role_arn = module.iam.role_ssm_ec2.arn
  depends_on = [module.iam]
}
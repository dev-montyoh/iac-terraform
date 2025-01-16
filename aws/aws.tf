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
  role_ssm_ec2_name = module.iam.role_ssm_ec2.name

  depends_on = [module.iam]
}

module "ssm" {
  source                          = "./ssm"
  # role_name                       = module.iam.role_ssm_ec2.name
  # role_arn                        = module.iam.role_ssm_ec2.arn
  ec2_instance_database_server_id = module.ec2.ec2_instance_database_server_id
  depends_on = [module.ec2]
}
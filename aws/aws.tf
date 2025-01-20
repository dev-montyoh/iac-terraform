/*
* AWS 에서 사용중인 서비스들에 대한 module 호출
*/
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
  source                                    = "./ec2"
  VPC_ID                                    = var.VPC_ID
  iam_instance_profile_ec2_managed_ssm_name = module.iam.iam_instance_profile_ec2_managed_ssm_name
  depends_on                                = [module.iam]
}

module "ssm" {
  source                                       = "./ssm"
  ec2_instance_database_server_id              = module.ec2.ec2_instance_database_server_id
  iam_role_ssm_maintenance_task_manage_ec2_arn = module.iam.iam_role_ssm_maintenance_task_manage_ec2_arn
  depends_on                                   = [module.iam, module.ec2]
}

module "billing" {
  source                = "./billing"
  BUDGETS_ALARM_TARGETS = var.BUDGETS_ALARM_TARGETS
}
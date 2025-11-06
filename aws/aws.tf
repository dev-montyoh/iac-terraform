/*
* AWS 에서 사용중인 서비스들에 대한 module 호출
*/
module "iam" {
  source          = "./iam"
  groups          = var.groups
  policies_aws    = var.policies_aws
  policies_custom = var.policies_custom
  users           = var.users
}

module "key_pair" {
  source             = "./key_pair"
  AWS_SSH_PUBLIC_KEY = var.AWS_SSH_PUBLIC_KEY
}

module "ec2" {
  source                                    = "./ec2"
  VPC_ID                                    = var.VPC_ID
  iam_instance_profile_ec2_managed_ssm_name = module.iam.iam_instance_profile_ec2_managed_ssm_name
  key_pair_name                             = module.key_pair.aws_ec2_ssh_public_key.key_name
  depends_on                                = [module.iam, module.key_pair]
  AWS_EC2_SSH_ALLOWED_IPS                   = var.AWS_EC2_SSH_ALLOWED_IPS
  AWS_EC2_USERDATA_GHCR_TOKEN               = var.AWS_EC2_USERDATA_GHCR_TOKEN
}

module "elastic_ip" {
  source                         = "./elastic_ip"
  ec2_instance_service_server_id = module.ec2.ec2_application_instance_id
  depends_on                     = [module.ec2]
}

module "lightsail" {
  source             = "./lightsail"
  AWS_SSH_PUBLIC_KEY = var.AWS_SSH_PUBLIC_KEY
  DB_USERNAME        = var.DB_USERNAME
  DB_PASSWORD        = var.DB_PASSWORD
}

# 생성된 ec2 에 대해서 자동 중지/시작 설정
module "ssm_application_instance" {
  source                                       = "./ssm"
  ec2_instance_id                              = module.ec2.ec2_application_instance_id
  iam_role_ssm_maintenance_task_manage_ec2_arn = module.iam.iam_role_ssm_maintenance_task_manage_ec2_arn
  depends_on                                   = [module.iam, module.ec2]
}

module "billing" {
  source                = "./billing"
  BUDGETS_ALARM_TARGETS = var.BUDGETS_ALARM_TARGETS
}

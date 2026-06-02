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

module "billing" {
  source                = "./billing"
  BUDGETS_ALARM_TARGETS = var.BUDGETS_ALARM_TARGETS
}

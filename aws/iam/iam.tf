module "group" {
  source             = "./group"
  for_each           = var.groups
  name               = each.value.name
  group_policies_aws = each.value.policies_aws
  policies_aws       = var.policies_aws
}

module "user" {
  source   = "./user"
  for_each = var.users
  name     = each.value.name
  path     = each.value.path
  email    = each.value.email
  groups   = each.value.groups
}

#  USER_ROLE
##  EC2 인스턴스 기동 시간 설정을 위한 USER_ROLE 생성
module "user_role_ec2_ssm" {
  source = "./role"

  name = "RoleForSystemManagerInstanceScheduler"
  path = "/role/iac/systemManager/instanceScheduler"
}

resource "aws_iam_role_policy_attachment" "attach_ec2_full_access" {
  role   = module.user_role_ec2_ssm.iam_role_info.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
}
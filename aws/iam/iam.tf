module "policy" {
  source      = "./policy"
  for_each    = var.policies_custom
  name        = each.value.name
  description = each.value.description
  policy      = each.value.policy
}

data "aws_iam_policy" "policies_custom_with_arn" {
  for_each = var.policies_custom
  name     = each.key
  depends_on = [module.policy]
}

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

#   USER_ROLE
##  EC2 인스턴스 자동 기동 설정을 위한 USER_ROLE 생성
module "role_ssm_ec2" {
  source = "./role"
  name = "RoleForSSMEC2"
  path = "/role/iac/ssm/ec2/"

  depends_on = [module.policy]
}

##  EC2 자동 재기동에 필요한 UserRole 에 설정하는 권한
resource "aws_iam_role_policy_attachment" "attach_role_ssm_ec2" {
  role       = module.role_ssm_ec2.iam_role_info.name
  policy_arn = lookup(data.aws_iam_policy.policies_custom_with_arn, "PolicyForSSMEC2").arn

  depends_on = [module.role_ssm_ec2, data.aws_iam_policy.policies_custom_with_arn]
}
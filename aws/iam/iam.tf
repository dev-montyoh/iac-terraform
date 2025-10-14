/*
* AWS IAM 서비스에 대한 설정
* 정책, 그룹, 회원, 역할...
*/

# 정책
module "policy" {
  source      = "./policy"
  for_each    = var.policies_custom
  name        = each.value.name
  description = each.value.description
  policy      = each.value.policy
}

# 정책 생성 결과
## 생성된 정책의 arn 값을 반환
data "aws_iam_policy" "iam_policies_custom_with_arn" {
  for_each   = var.policies_custom
  name       = each.key
  depends_on = [module.policy]
}

# 그룹
module "group" {
  source             = "./group"
  for_each           = var.groups
  name               = each.value.name
  group_policies_aws = each.value.policies_aws
  policies_aws       = var.policies_aws
}

# 사용자
module "user" {
  source   = "./user"
  for_each = var.users
  name     = each.value.name
  path     = each.value.path
  email    = each.value.email
  groups   = each.value.groups
}

# 역할
## SSM 의 관리를 받을 수 있도록 하는 IAM Role
## 대상 EC2 인스턴스에 부여
module "iam_role_ec2_managed_ssm" {
  source             = "./role"
  name               = "IAMRoleEC2ManagedSSM"
  path               = "/"
  assume_role_policy = {
    Version   = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  }
}

#   IAM Role 과 Policy 연결
##  SSM 에게 관리를 받을 수 있도록 하는 정책을 부여한다.
resource "aws_iam_role_policy_attachment" "attach_iam_role_ec2_managed_ssm" {
  role       = module.iam_role_ec2_managed_ssm.iam_role_name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  depends_on = [module.iam_role_ec2_managed_ssm]
}

#   IAM Instance Profile
##  EC2 인스턴스에 IAM Role 을 붙이기 위한 프로필 설정
resource "aws_iam_instance_profile" "iam_instance_profile_ec2_managed_ssm" {
  name       = "IAMInstanceProfileEC2ManagedSSM"
  role       = module.iam_role_ec2_managed_ssm.iam_role_name
  depends_on = [module.iam_role_ec2_managed_ssm]
}

## SSM Maintenance Task 가 EC2 인스턴스를 관리할 수 있도록 하는 IAM Role
module "iam_role_ssm_maintenance_task_manage_ec2" {
  source             = "./role"
  name               = "IAMRoleSSMMaintenanceTaskManageEC2"
  path               = "/"
  assume_role_policy = {
    Version   = "2012-10-17",
    Statement = [
      {
        Effect    = "Allow",
        Principal = {
          Service = "ssm.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  }
}

#   IAM Role 과 Policy 연결
##  사전 생성한 정책을 연결한다.
resource "aws_iam_role_policy_attachment" "attach_iam_role_ssm_maintenance_task_manage_ec2" {
  role       = module.iam_role_ssm_maintenance_task_manage_ec2.iam_role_name
  policy_arn = lookup(data.aws_iam_policy.iam_policies_custom_with_arn, "IAMPolicyForSSMMaintenanceTaskManageEC2").arn
  depends_on = [module.iam_role_ssm_maintenance_task_manage_ec2]
}
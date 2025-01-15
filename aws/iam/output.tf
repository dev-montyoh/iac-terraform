output "role_ssm_ec2" {
  value = module.role_ssm_ec2.iam_role_info
  description = "IAM Role information for SSM Instance Scheduler"
}
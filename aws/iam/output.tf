output "iam_instance_profile_ec2_managed_ssm_name" {
  value = aws_iam_instance_profile.iam_instance_profile_ec2_managed_ssm.name
}

output "iam_role_ssm_maintenance_task_manage_ec2_arn" {
  value = module.iam_role_ssm_maintenance_task_manage_ec2.iam_role_arn
}
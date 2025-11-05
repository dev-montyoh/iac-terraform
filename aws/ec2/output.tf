output "ec2_application_instance_id" {
  value = module.ec2_application_instance.ec2_instance_id
}

output "ec2_database_instance_id" {
  value = module.ec2_database_instance.ec2_instance_id
}
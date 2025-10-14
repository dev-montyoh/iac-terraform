variable "ssm_maintenance_window_start_id" { type = string }
variable "ssm_maintenance_window_stop_id" { type = string }
variable "ssm_maintenance_window_target_start_id" { type = string }
variable "ssm_maintenance_window_target_stop_id" { type = string }
variable "ec2_instance_database_server_id" { type = string }
variable "iam_role_ssm_maintenance_task_manage_ec2_arn" { type = string }
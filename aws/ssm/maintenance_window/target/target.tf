# 유지 관리 기간/타겟 설정
resource "aws_ssm_maintenance_window_target" "start_target" {
  window_id     = var.ssm_maintenance_window_start_id
  name          = "SSMMaintenanceWindowTargetStartEC2"
  resource_type = "INSTANCE"
  targets {
    key    = "InstanceIds"
    values = [var.ec2_instance_database_server_id]
  }
}

resource "aws_ssm_maintenance_window_target" "stop_target" {
  window_id     = var.ssm_maintenance_window_stop_id
  name          = "SSMMaintenanceWindowTargetStopEC2"
  resource_type = "INSTANCE"
  targets {
    key    = "InstanceIds"
    values = [var.ec2_instance_database_server_id]
  }
}

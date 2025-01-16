# 4. Maintenance Window Targets
resource "aws_ssm_maintenance_window_target" "start_target" {
  window_id     = var.ssm_maintenance_window_start_id
  name          = "StartEC2Target"
  resource_type = "INSTANCE"
  targets {
    key = "InstanceIds"
    values = ["i-07dc793ff8de87f45"]
  }
}

resource "aws_ssm_maintenance_window_task" "start_task" {
  window_id        = var.ssm_maintenance_window_start_id
  task_arn         = var.ssm_document_start_arn
  service_role_arn = var.role_arn
  task_type        = "AUTOMATION"
  priority         = 1
  max_concurrency  = "1"
  max_errors       = "1"

  targets {
    key = "InstanceIds"
    values = ["i-07dc793ff8de87f45"]
  }
}

resource "aws_ssm_maintenance_window_target" "stop_target" {
  window_id     = var.ssm_maintenance_window_stop_id
  name          = "StopEC2Target"
  resource_type = "INSTANCE"
  targets {
    key = "InstanceIds"
    values = ["i-07dc793ff8de87f45"]
  }
}

resource "aws_ssm_maintenance_window_task" "stop_task" {
  window_id        = var.ssm_maintenance_window_stop_id
  task_arn         = var.ssm_document_stop_arn
  service_role_arn = var.role_arn
  task_type        = "AUTOMATION"
  priority         = 1
  max_concurrency  = "1"
  max_errors       = "1"

  targets {
    key = "InstanceIds"
    values = ["i-07dc793ff8de87f45"]
  }
}
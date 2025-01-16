resource "aws_ssm_maintenance_window_task" "start_task" {
  window_id = var.ssm_maintenance_window_start_id
  task_arn  = "AWS-StartEC2Instance"
  task_type = "RUN_COMMAND"

  targets {
    key = "WindowTargetIds"
    values = [var.ssm_maintenance_window_target_start_id]
  }

  priority        = 1
  max_concurrency = "1"
  max_errors      = "1"
}

resource "aws_ssm_maintenance_window_task" "stop_task" {
  window_id = var.ssm_maintenance_window_stop_id
  task_arn  = "AWS-StopEC2Instance"
  task_type = "RUN_COMMAND"

  targets {
    key = "WindowTargetIds"
    values = [var.ssm_maintenance_window_target_stop_id]
  }

  priority        = 1
  max_concurrency = "1"
  max_errors      = "1"
}
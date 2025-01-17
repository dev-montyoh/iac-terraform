/*
* AWS 유지관리기간 작업 설정
*/
resource "aws_ssm_maintenance_window_task" "start_task" {
  window_id = var.ssm_maintenance_window_start_id
  task_arn  = "AWS-StartEC2Instance"    # AWS 기본 정의 Document 사용
  task_type = "AUTOMATION"

  targets {
    key    = "InstanceIds"
    values = [var.ec2_instance_database_server_id]
  }

  priority        = 1
  max_concurrency = "1"
  max_errors      = "1"

  task_invocation_parameters {
    automation_parameters {
      document_version = "$LATEST"

      parameter {
        name   = "InstanceId"
        values = [var.ec2_instance_database_server_id]
      }
    }
  }
}

resource "aws_ssm_maintenance_window_task" "stop_task" {
  window_id        = var.ssm_maintenance_window_stop_id
  task_arn         = "AWS-StopEC2Instance"  # AWS 기본 정의 Document 사용ø
  task_type        = "AUTOMATION"
  priority         = 1
  max_concurrency  = "1"
  max_errors       = "1"
  service_role_arn = var.iam_role_ssm_maintenance_task_manage_ec2_arn

  targets {
    key    = "WindowTargetIds"
    values = [var.ssm_maintenance_window_target_stop_id]
  }

  task_invocation_parameters {
    automation_parameters {
      document_version = "$LATEST"

      parameter {
        name   = "InstanceId"
        values = [var.ec2_instance_database_server_id]
      }
    }
  }
}
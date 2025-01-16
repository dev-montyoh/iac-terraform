## 테스트 임시 추가
resource "aws_iam_policy" "ssm_maintenance_policy" {
  name        = "SSMMaintenancePolicy"
  description = "Policy for SSM Maintenance Window Tasks"

  policy = jsonencode({
    Version   = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ssm:SendCommand",
          "ec2:StartInstances",
          "ec2:StopInstances",
          "ssm:StartAutomationExecution"  # 추가
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role" "ssm_maintenance_role" {
  name               = "SSMMaintenanceRole"
  assume_role_policy = jsonencode({
    Version   = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Principal = {
          Service = "ssm.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ssm_maintenance_policy_attachment" {
  role       = aws_iam_role.ssm_maintenance_role.name
  policy_arn = aws_iam_policy.ssm_maintenance_policy.arn
}

resource "aws_ssm_maintenance_window_task" "start_task" {
  window_id = var.ssm_maintenance_window_start_id
  task_arn  = "AWS-StartEC2Instance"
  task_type = "AUTOMATION"

  targets {
    key    = "InstanceIds"
    values = [var.ec2_instance_database_server_id]
  }

  priority        = 1
  max_concurrency = "1"
  max_errors      = "1"

  # IAM Role 추가
#  service_role_arn = aws_iam_role.ssm_maintenance_role.arn

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
  window_id = var.ssm_maintenance_window_stop_id
  task_arn  = "AWS-StopEC2Instance"
  task_type = "AUTOMATION"

  targets {
    key    = "InstanceIds"
    values = [var.ec2_instance_database_server_id]
  }

  priority        = 1
  max_concurrency = "1"
  max_errors      = "1"

  # IAM Role 추가
#  service_role_arn = aws_iam_role.ssm_maintenance_role.arn

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
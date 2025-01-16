# 테스트 임시 추가
resource "aws_iam_policy" "ssm_task_policy" {
  name        = "ssm_task_policy"
  description = "Policy for Systems Manager to manage EC2 instances"
  policy      = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = [
          "ec2:StartInstances",
          "ec2:StopInstances"
        ],
        Resource = "arn:aws:ec2:*:*:instance/*" # 필요에 따라 특정 인스턴스로 제한 가능
      }
    ]
  })
}

resource "aws_iam_role" "ssm_task_role" {
  name = "ssm_task_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "ssm.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "attach_ssm_task_policy" {
  role       = aws_iam_role.ssm_task_role.name
  policy_arn = aws_iam_policy.ssm_task_policy.arn
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

  task_invocation_parameters {
    automation_parameters {
      document_version = "$LATEST"

      parameter {
        name   = "InstanceId"
        values = [var.ec2_instance_database_server_id]
      }
      parameter {
        name   = "AutomationAssumeRole"
        values = [aws_iam_role.ssm_task_role.arn]
      }
    }
  }
}
# 테스트 임시 추가
resource "aws_iam_policy" "ssm_task_policy" {
  name        = "ssm_task_policy"
  description = "Policy for Systems Manager to manage EC2 instances"
  policy      = jsonencode({
    Version   = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "ec2:StopInstances", # EC2 인스턴스 중지 권한
          "ec2:DescribeInstances", # EC2 인스턴스 상태 조회 권한
          "ec2:DescribeInstanceStatus",
          "ssm:StartAutomationExecution", # Automation 문서 실행 권한
          "ssm:GetAutomationExecution", # Automation 실행 상태 조회 권한
          "iam:PassRole"                  # 역할 전달 권한
        ],
        Resource : "*"
      }
    ]
  })
}

resource "aws_iam_role" "ssm_task_role" {
  name = "ssm_task_role"

  assume_role_policy = jsonencode({
    Version   = "2012-10-17",
    Statement = [
      {
        Effect    = "Allow",
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

##########################
## AWS 유지관리기간 작업 설정
##########################
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
  task_arn         = "AWS-StopEC2Instance"
  task_type        = "AUTOMATION"
  priority         = 1
  max_concurrency  = "1"
  max_errors       = "1"
  service_role_arn = aws_iam_role.ssm_task_role.arn

  targets {
    key    = "WindowTargetIds"
    values = [var.ssm_maintenance_window_target_stop_id]
  }
}
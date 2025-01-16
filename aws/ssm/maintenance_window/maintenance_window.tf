## EC2 Instance 시작 시간 정의
resource "aws_ssm_maintenance_window" "start_window" {
  name = "EC2SchedulerStartWindow"

  # 오전 8시 시작
  schedule                   = "cron(0 15 ? * * *)"
  duration                   = 1
  cutoff                     = 0
  allow_unassociated_targets = true
}

## EC2 Instance 종료 시간 정의
resource "aws_ssm_maintenance_window" "stop_window" {
  name = "EC2SchedulerStopWindow"

  # 오전 12시 종료
  schedule                   = "cron(0 14 ? * * *)"
  duration                   = 1
  cutoff                     = 0
  allow_unassociated_targets = true
}

##  SSM Maintenance Window Task(유지 관리 기간/작업) 정의
module "ssm_maintenance_window_task" {
  source                          = "./task"
  role_arn                        = var.role_arn
  role_name                       = var.role_name
  ssm_document_start_arn          = var.ssm_document_start_arn
  ssm_document_stop_arn           = var.ssm_document_stop_arn
  ssm_maintenance_window_start_id = aws_ssm_maintenance_window.start_window.id
  ssm_maintenance_window_stop_id  = aws_ssm_maintenance_window.stop_window.id
}
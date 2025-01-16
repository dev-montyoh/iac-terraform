## EC2 Instance 시작 시간 정의
### 오전 8시 시작
resource "aws_ssm_maintenance_window" "start_window" {
  name                       = "EC2SchedulerWindowStart"
  schedule                   = "cron(50 9 ? * * *)"
  schedule_timezone          = "Asia/Seoul"
  duration                   = 1
  cutoff                     = 0
  allow_unassociated_targets = true
}

## EC2 Instance 종료 시간 정의
### 오전 12시 종료
resource "aws_ssm_maintenance_window" "stop_window" {
  name                       = "EC2SchedulerWindowStop"
  schedule                   = "cron(45 9 ? * * *)"
  schedule_timezone          = "Asia/Seoul"
  duration                   = 1
  cutoff                     = 0
  allow_unassociated_targets = true
}

##  SSM Maintenance Window Task(유지 관리 기간/대상) 정의
module "ssm_maintenance_window_target" {
  source                          = "./target"
  ssm_maintenance_window_start_id = aws_ssm_maintenance_window.start_window.id
  ssm_maintenance_window_stop_id  = aws_ssm_maintenance_window.stop_window.id
  ec2_instance_database_server_id = var.ec2_instance_database_server_id
  depends_on                      = [aws_ssm_maintenance_window.start_window, aws_ssm_maintenance_window.stop_window]
}

##  SSM Maintenance Window Task(유지 관리 기간/작업) 정의
module "ssm_maintenance_window_task" {
  source                                 = "./task"
  # role_arn                               = var.role_arn
  # role_name                              = var.role_name
  # ssm_document_start_arn          = var.ssm_document_start_arn
  # ssm_document_stop_arn           = var.ssm_document_stop_arn
  ssm_maintenance_window_start_id        = aws_ssm_maintenance_window.start_window.id
  ssm_maintenance_window_stop_id         = aws_ssm_maintenance_window.stop_window.id
  ssm_maintenance_window_target_start_id = module.ssm_maintenance_window_target.aws_ssm_maintenance_window_target_start.id
  ssm_maintenance_window_target_stop_id  = module.ssm_maintenance_window_target.aws_ssm_maintenance_window_target_stop.id
  ec2_instance_database_server_id        = var.ec2_instance_database_server_id
  depends_on                             = [
    aws_ssm_maintenance_window.start_window, aws_ssm_maintenance_window.stop_window,
    module.ssm_maintenance_window_target
  ]
}
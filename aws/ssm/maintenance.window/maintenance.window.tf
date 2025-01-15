## EC2 Instance 시작 시간 정의
resource "aws_ssm_maintenance_window" "start_window" {
  name = "EC2SchedulerStartWindow"

  # 오전 8시 시작
  schedule                   = "cron(0 8 ? * * *)"
  duration                   = 1
  cutoff                     = 0
  allow_unassociated_targets = true
}

## EC2 Instance 종료 시간 정의
resource "aws_ssm_maintenance_window" "stop_window" {
  name = "EC2SchedulerStopWindow"

  # 오후 12시 종료
  schedule                   = "cron(0 0 ? * * *)"
  duration                   = 1
  cutoff                     = 0
  allow_unassociated_targets = true
}
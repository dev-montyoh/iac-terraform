#   SSM 설정
##  EC2 자동 시작 설정
resource "aws_ssm_document" "start_ec2_instances" {
  name          = "StartEC2Instances"
  document_type = "Automation"
  content = jsonencode({
    schemaVersion = "0.3"
    description   = "Start EC2 Instances"
    mainSteps = [
      {
        name   = "startInstances"
        action = "aws:runInstances"
        inputs = {
          InstanceIds = "{{ InstanceIds }}"
        }
      }
    ]
  })
}

##  EC2 자동 종료 설정
resource "aws_ssm_document" "stop_ec2_instances" {
  content       = "StopEC2Instances"
  document_type = "Automation"
  name = jsonencode({
    schemaVersion = "0.3"
    description   = "Stop EC2 Instances"
    mainSteps = [
      {
        name   = "stopInstances"
        action = "aws:stopInstances"
        inputs = {
          InstanceIds = "{{ InstanceIds }}"
        }
      }
    ]
  })
}
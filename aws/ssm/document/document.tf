##  EC2 자동 시작 설정
resource "aws_ssm_document" "start_ec2_instances" {
  name          = "StartEC2InstancesSSMDocument"
  document_type = "Automation"
  content = jsonencode({
    "schemaVersion" : "0.3",
    "description" : "Start EC2 instances",
    "parameters" : {
      "InstanceIds" : {
        "type" : "StringList",
        "description" : "List of EC2 instance IDs to start"
      }
    },
    "mainSteps" : [
      {
        "action" : "aws:changeInstanceState",
        "name" : "startInstances",
        "inputs" : {
          "InstanceIds" : "{{InstanceIds}}",
          "DesiredState" : "running"
        }
      }
    ]
  })
}

##  EC2 자동 종료 설정
resource "aws_ssm_document" "stop_ec2_instances" {
  name          = "StopEC2InstancesSSMDocument"
  document_type = "Automation"
  content = jsonencode({
    "schemaVersion" : "0.3",
    "description" : "Stop EC2 instances",
    "parameters" : {
      "InstanceIds" : {
        "type" : "StringList",
        "description" : "List of EC2 instance IDs to stop"
      }
    },
    "mainSteps" : [
      {
        "action" : "aws:changeInstanceState",
        "name" : "stopInstances",
        "inputs" : {
          "InstanceIds" : "{{InstanceIds}}",
          "DesiredState" : "stopped"
        }
      }
    ]
  })
}
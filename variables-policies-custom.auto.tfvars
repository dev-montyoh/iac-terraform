policies_custom = {
  "IAMPolicyForSSMMaintenanceTaskManageEC2" = {
    name        = "IAMPolicyForSSMMaintenanceTaskManageEC2"
    description = "IAM Policy for SSM Maintenance Task Manage EC2"
    policy      = {
      Version   = "2012-10-17",
      Statement = [
        {
          Effect = "Allow",
          Action = [
            "ec2:StopInstances",            # EC2 인스턴스 중지 권한
            "ec2:DescribeInstances",        # EC2 인스턴스 세부 정보 조회 권한
            "ec2:DescribeInstanceStatus",   # EC2 인스턴스 상태 조회 권한
            "ssm:StartAutomationExecution", # Automation 문서 실행 권한
            "ssm:GetAutomationExecution",   # Automation 실행 상태 조회 권한
            "iam:PassRole"                  # 역할 전달 권한
          ],
          Resource : "*"
        }
      ]
    }
  }
}
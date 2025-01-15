policies_custom = {
  "PolicyForSystemManagerInstanceScheduler" = {
    name        = "PolicyForSystemManagerInstanceScheduler"
    description = "Policy for Instance Scheduler"
    policy = {
      Version = "2012-10-17"
      Statement = [
        {
          Effect = "Allow"
          Action = [
            "ec2:StartInstances",
            "ec2:StopInstances",
            "ec2:DescribeInstances"
          ]
          Resource = "*"
        }
      ]
    }
  }
}
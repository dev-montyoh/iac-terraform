policies_custom = {
  "PolicyForSSMEC2" = {
    name        = "PolicyForSSMEC2"
    description = "PolicyForSSMEC2"
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
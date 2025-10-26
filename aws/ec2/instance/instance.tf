resource "aws_instance" "ec2_instance" {
  instance_type          = var.instance_type
  ami                    = var.ami
  vpc_security_group_ids = var.vpc_security_group_ids
  user_data              = var.user_data
  iam_instance_profile   = var.profile_name
  key_name               = var.key_pair_name

  tags = {
    Name = var.instance_name
  }

  # 강제 종료 및 강제 삭제 금지
  disable_api_termination = true
  lifecycle {
    prevent_destroy = true
  }
}

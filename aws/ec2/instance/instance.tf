resource "aws_instance" "ec2_instance" {
  instance_type          = var.instance_type
  ami                    = var.ami
  vpc_security_group_ids = var.vpc_security_group_ids
  user_data              = var.user_data
  iam_instance_profile   = var.profile_name

  tags = {
    Name = var.instance_name
  }
}
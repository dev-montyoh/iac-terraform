resource "aws_instance" "ec2_instance" {
  instance_type = var.instance_type
  ami           = var.ami
  vpc_security_group_ids = var.vpc_security_group_ids

  tags = {
    Name = var.instance_name
  }
}
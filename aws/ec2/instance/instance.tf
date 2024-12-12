resource "aws_instance" "ec2_instance" {
  instance_type = "t2.micro"
  ami           = "ami-0f1e61a80c7ab943e"
  vpc_security_group_ids = var.vpc_security_group_ids

  tags = {
    Name = var.instance_name
  }
}
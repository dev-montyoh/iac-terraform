resource "aws_lightsail_key_pair" "aws_lightsail_key" {
  name = "aws_lightsail_key"
  public_key = var.AWS_SSH_PUBLIC_KEY
}
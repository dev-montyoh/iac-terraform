
resource "aws_key_pair" "aws_ec2_ssh_public_key" {
  key_name   = "aws_ec2_ssh_public_key"
  public_key = var.AWS_SSH_PUBLIC_KEY
}

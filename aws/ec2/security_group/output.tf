output "ec2_security_group_ssh_info" {
  value = aws_security_group.security_group_ssh
}

output "ec2_security_group_web_info" {
  value = aws_security_group.security_group_web
}
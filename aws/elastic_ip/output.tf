output "service_server_public_ip" {
  value = aws_eip.service_server_eip.public_ip
}
output "database_server_public_ip" {
  value = aws_lightsail_static_ip.database_lightsail_static_ip.ip_address
}
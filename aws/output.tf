output "service_server_public_ip" {
  value = module.lightsail.service_server_public_ip
}

output "database_server_public_ip" {
  value = module.lightsail.database_server_public_ip
}

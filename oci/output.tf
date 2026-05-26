output "service_server_public_ip" {
  value = module.application_instance.public_ip
}

output "service_server_small_public_ip" {
  value = module.application_instance_small.public_ip
}

output "database_server_public_ip" {
  value = module.database_instance.public_ip
}

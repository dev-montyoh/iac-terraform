output "endpoint" {
  value = oci_mysql_mysql_db_system.xcelerate_db.endpoints[0].hostname
}

output "port" {
  value = oci_mysql_mysql_db_system.xcelerate_db.endpoints[0].port
}

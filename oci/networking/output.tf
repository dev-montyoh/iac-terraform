output "app_subnet_id" {
  value = oci_core_subnet.app_subnet.id
}

output "db_subnet_id" {
  value = oci_core_subnet.db_subnet.id
}

output "vcn_id" {
  value = oci_core_vcn.vcn.id
}

data "oci_identity_availability_domains" "ads" {
  compartment_id = var.compartment_id
}

resource "oci_mysql_mysql_db_system" "xcelerate_db" {
  compartment_id      = var.compartment_id
  availability_domain = data.oci_identity_availability_domains.ads.availability_domains[0].name
  shape_name              = "MySQL.Free"
  subnet_id               = var.subnet_id
  admin_username          = "admin"
  admin_password          = var.admin_password
  display_name            = "XCELERATE_DB"
  data_storage_size_in_gb = 50
  is_highly_available     = false

  maintenance {
    window_start_time = "MONDAY 03:00"
  }
}

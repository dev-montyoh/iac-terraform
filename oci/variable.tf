variable "OCI_TENANCY_OCID"        { type = string }
variable "OCI_MYSQL_ADMIN_PASSWORD" {
  type      = string
  sensitive = true
}

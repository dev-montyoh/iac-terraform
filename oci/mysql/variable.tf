variable "compartment_id" { type = string }
variable "subnet_id"      { type = string }
variable "admin_password" {
  type      = string
  sensitive = true
}

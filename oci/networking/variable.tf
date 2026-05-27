variable "compartment_id" { type = string }
variable "vcn_name"       { type = string }

variable "cidr_block" {
  type    = string
  default = "10.0.0.0/16"
}

variable "app_subnet_cidr" {
  type    = string
  default = "10.0.1.0/24"
}

variable "db_subnet_cidr" {
  type    = string
  default = "10.0.2.0/24"
}

variable "app_ingress_ports" {
  type    = list(number)
  default = [22, 80, 443]
}

variable "db_ingress_ports" {
  type    = list(number)
  default = [22, 5432]
}

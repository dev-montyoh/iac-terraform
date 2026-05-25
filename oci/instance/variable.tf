variable "compartment_id" { type = string }
variable "instance_name"  { type = string }
variable "subnet_id"      { type = string }
variable "ssh_public_key" { type = string }
variable "user_data"      { type = string }

variable "ocpus" {
  type    = number
  default = 1
}

variable "memory_in_gbs" {
  type    = number
  default = 6
}

variable "instance_name" { type = string }
variable "instance_type" { type = string }
variable "ami" { type = string }
variable "vpc_security_group_ids" { type = list(string) }
variable "user_data" { type = string }
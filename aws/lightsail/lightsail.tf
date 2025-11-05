resource "aws_lightsail_static_ip" "database_lightsail_static_ip" {
  name = "database_lightsail_static_ip"
}

resource "aws_lightsail_instance" "db_instance" {
  name              = "MONTY_DATABASE_INSTANCE"
  bundle_id         = "nano_3_0"
  blueprint_id      = "ubuntu_22_04"
  key_pair_name     = var.key_pair_name
  availability_zone = "ap-northeast-2a"
  user_data         = file("scripts/lightsail_database_instance_userdata.sh")
}

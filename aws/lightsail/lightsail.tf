resource "aws_lightsail_static_ip" "database_lightsail_static_ip" {
  name = "database_lightsail_static_ip"
}

module "aws_lightsail_key_pair" {
  source = "./key_pair"
  AWS_SSH_PUBLIC_KEY = var.AWS_SSH_PUBLIC_KEY
}

resource "aws_lightsail_instance" "db_instance" {
  name              = "MONTY_DATABASE_INSTANCE"
  bundle_id         = "nano_3_0"
  blueprint_id      = "ubuntu_22_04"
  key_pair_name     = module.aws_lightsail_key_pair.aws_lightsail_key.name
  availability_zone = "ap-northeast-2a"
  user_data         = file("scripts/lightsail_database_instance_userdata.sh")
}

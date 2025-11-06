resource "aws_lightsail_static_ip" "database_lightsail_static_ip" {
  name = "database_lightsail_static_ip"
}

module "aws_lightsail_key_pair" {
  source             = "./key_pair"
  AWS_SSH_PUBLIC_KEY = var.AWS_SSH_PUBLIC_KEY
}

resource "aws_lightsail_instance" "db_instance" {
  name              = "MONTY_DB_INSTANCE"
  bundle_id         = "nano_3_0"
  blueprint_id      = "ubuntu_22_04"
  key_pair_name     = module.aws_lightsail_key_pair.aws_lightsail_key.name
  availability_zone = "ap-northeast-2a"
  user_data = templatefile("scripts/lightsail_database_instance_userdata.sh",
    {
      DB_USERNAME = var.DB_USERNAME
      DB_PASSWORD = var.DB_PASSWORD
      PG_VERSION = 14
    }
  )
  depends_on = [module.aws_lightsail_key_pair]
}

resource "aws_lightsail_static_ip_attachment" "aws_lightsail_static_ip_attachment" {
  instance_name  = aws_lightsail_instance.db_instance.name
  static_ip_name = aws_lightsail_static_ip.database_lightsail_static_ip.name
  depends_on     = [aws_lightsail_static_ip.database_lightsail_static_ip, aws_lightsail_instance.db_instance]
}

resource "aws_lightsail_instance_public_ports" "db_firewall" {
  instance_name = aws_lightsail_instance.db_instance.name

  port_info {
    protocol  = "tcp"
    from_port = 22
    to_port   = 22
  }

  port_info {
    protocol  = "tcp"
    from_port = 5432
    to_port   = 5432
    cidrs     = ["0.0.0.0/0"]
  }

  depends_on = [aws_lightsail_instance.db_instance]
}

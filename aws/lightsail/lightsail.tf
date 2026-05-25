# 애플리케이션 Lightsail 인스턴스
resource "aws_lightsail_static_ip" "application_lightsail_static_ip" {
  name = "application_lightsail_static_ip"
}

resource "aws_lightsail_instance" "application_instance" {
  name              = "MONTY_APPLICATION_INSTANCE"
  bundle_id         = "small_3_0"
  blueprint_id      = "ubuntu_22_04"
  key_pair_name     = module.aws_lightsail_key_pair.aws_lightsail_key.name
  availability_zone = "ap-northeast-2a"
  user_data = templatefile("scripts/lightsail_application_instance_userdata.sh",
    {
      AWS_EC2_USERDATA_GHCR_TOKEN = var.AWS_EC2_USERDATA_GHCR_TOKEN
    }
  )
  depends_on = [module.aws_lightsail_key_pair]
}

resource "aws_lightsail_static_ip_attachment" "application_lightsail_static_ip_attachment" {
  instance_name  = aws_lightsail_instance.application_instance.name
  static_ip_name = aws_lightsail_static_ip.application_lightsail_static_ip.name
  depends_on     = [aws_lightsail_static_ip.application_lightsail_static_ip, aws_lightsail_instance.application_instance]
}

resource "aws_lightsail_instance_public_ports" "application_firewall" {
  instance_name = aws_lightsail_instance.application_instance.name

  port_info {
    protocol  = "tcp"
    from_port = 22
    to_port   = 22
  }

  port_info {
    protocol  = "tcp"
    from_port = 80
    to_port   = 80
    cidrs     = ["0.0.0.0/0"]
  }

  port_info {
    protocol  = "tcp"
    from_port = 443
    to_port   = 443
    cidrs     = ["0.0.0.0/0"]
  }

  lifecycle {
    ignore_changes = [
      port_info
    ]
  }

  depends_on = [aws_lightsail_instance.application_instance]
}

# 데이터베이스 Lightsail 인스턴스
resource "aws_lightsail_static_ip" "database_lightsail_static_ip" {
  name = "database_lightsail_static_ip"
}

module "aws_lightsail_key_pair" {
  source             = "./key_pair"
  AWS_SSH_PUBLIC_KEY = var.AWS_SSH_PUBLIC_KEY
}

resource "aws_lightsail_instance" "db_instance" {
  name              = "MONTY_DATABASE_INSTANCE"
  bundle_id         = "micro_3_0"
  blueprint_id      = "ubuntu_22_04"
  key_pair_name     = module.aws_lightsail_key_pair.aws_lightsail_key.name
  availability_zone = "ap-northeast-2a"
  user_data = templatefile("scripts/lightsail_database_instance_userdata.sh",
    {
      DB_USERNAME = var.DB_USERNAME
      DB_PASSWORD = var.DB_PASSWORD
      PG_VERSION  = 14
    }
  )
  depends_on = [module.aws_lightsail_key_pair]
}

resource "aws_lightsail_static_ip_attachment" "aws_lightsail_static_ip_attachment" {
  instance_name  = aws_lightsail_instance.db_instance.name
  static_ip_name = aws_lightsail_static_ip.database_lightsail_static_ip.name
  depends_on     = [aws_lightsail_static_ip.database_lightsail_static_ip, aws_lightsail_instance.db_instance]

  lifecycle {
    replace_triggered_by = [aws_lightsail_instance.db_instance]
  }
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

  lifecycle {
    ignore_changes = [
      port_info
    ]
  }

  depends_on = [aws_lightsail_instance.db_instance]
}

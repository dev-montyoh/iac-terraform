# 보안 그룹
module "security_group" {
  source = "./security_group"
  VPC_ID = var.VPC_ID
}

# 테스트용 임시 ec2 인스턴스
## Amazon Linux 2023 AMI
module "temp_ec2_instance" {
  source        = "./instance"
  instance_name = "temp_ec2_instance"
  instance_type = "t2.micro"
  ami           = "ami-0f1e61a80c7ab943e"
  user_data = file("scripts/temp_ec2_userdata.sh")

  vpc_security_group_ids = [module.security_group.ec2_security_group_ssh_info.id]

  depends_on = [module.security_group]
}

#   DB 서버 전용 인스턴스
##  Amazon Linux 2023 AMI
module "ec2_db_server_instance" {
  source = "./instance"
  ami           = "ami-049788618f07e189d"
  instance_name = "db_server"
  instance_type = "t2.micro"
  user_data     = file("scripts/ec2_database_server_userdata.sh")
  # 보안 그룹 설정
  vpc_security_group_ids = [module.security_group.ec2_security_group_ssh_info.id]

  depends_on = [module.security_group]
}
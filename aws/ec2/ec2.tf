/*
* AWS EC2 에서 사용중인 서비스들에 대한 모듈 호출
*/

# 보안 그룹
module "security_group" {
  source = "./security_group"
  VPC_ID = var.VPC_ID
}

# EC2 인스턴스
## DB 서버 전용 인스턴스
## Amazon Linux 2023 AMI
module "ec2_db_server_instance" {
  source                 = "./instance"
  ami                    = "ami-049788618f07e189d"
  instance_name          = "database_server"
  instance_type          = "t2.micro"
  user_data              = file("scripts/ec2_database_server_userdata.sh")
  profile_name           = var.iam_instance_profile_ec2_managed_ssm_name
  vpc_security_group_ids = [module.security_group.ec2_security_group_ssh_info.id]
  depends_on             = [module.security_group]
}
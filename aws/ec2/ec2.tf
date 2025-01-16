# 보안 그룹
module "security_group" {
  source = "./security_group"
  VPC_ID = var.VPC_ID
}

resource "aws_iam_instance_profile" "ssm_profile" {
  name = "SSMInstanceProfile"
  role = var.role_ssm_ec2_name
}

#   DB 서버 전용 인스턴스
##  Amazon Linux 2023 AMI
module "ec2_db_server_instance" {
  source = "./instance"
  ami           = "ami-049788618f07e189d"
  instance_name = "database_server"
  instance_type = "t2.micro"
  user_data     = file("scripts/ec2_database_server_userdata.sh")
  profile_name = aws_iam_instance_profile.ssm_profile.name
  # 보안 그룹 설정
  vpc_security_group_ids = [module.security_group.ec2_security_group_ssh_info.id]

  depends_on = [module.security_group, aws_iam_instance_profile.ssm_profile]
}
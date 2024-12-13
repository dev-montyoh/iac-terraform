# 보안그룹
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

  vpc_security_group_ids = [module.security_group.ec2_security_group_ssh_info.id]

  depends_on = [module.security_group]
}
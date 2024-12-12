# 보안그룹
module "security_group" {
  source = "./security_group"
  VPC_ID = var.VPC_ID
}

# 테스트용 임시 ec2 인스턴스
module "temp_ec2_instance" {
  source = "./instance"
  instance_name = "temp_ec2_instance"
  security_group_ids = [module.security_group.ec2_security_group_ssh_info.id]
}
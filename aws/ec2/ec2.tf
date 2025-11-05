/*
* AWS EC2 에서 사용중인 서비스들에 대한 모듈 호출
*/

# 보안 그룹
module "security_group" {
  source                  = "./security_group"
  VPC_ID                  = var.VPC_ID
  AWS_EC2_SSH_ALLOWED_IPS = var.AWS_EC2_SSH_ALLOWED_IPS
}

# EC2 인스턴스
## 애플리케이션 전용 인스턴스
module "ec2_application_instance" {
  source                 = "./instance"
  ami                    = "ami-049788618f07e189d"
  instance_name          = "MONTY_APPLICATION_INSTANCE"
  instance_type          = "t2.micro"
  user_data              = templatefile("scripts/ec2_application_instance_userdata.sh", { AWS_EC2_USERDATA_GHCR_TOKEN = var.AWS_EC2_USERDATA_GHCR_TOKEN })
  profile_name           = var.iam_instance_profile_ec2_managed_ssm_name
  vpc_security_group_ids = [module.security_group.ec2_security_group_ssh_info.id, module.security_group.ec2_security_group_web_info.id]
  key_pair_name          = var.key_pair_name
  depends_on             = [module.security_group]
}

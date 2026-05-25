/*
* OCI 에서 사용중인 서비스들에 대한 모듈 호출
*/

# 네트워크 (VCN, 서브넷, 보안그룹, IGW)
module "networking" {
  source         = "./networking"
  compartment_id = var.OCI_TENANCY_OCID
  vcn_name       = "MONTY_APP"
  cidr_block     = "10.0.0.0/16"
  subnet_cidr    = "10.0.1.0/24"
  ingress_ports  = [22, 80, 443, 3306]
}

# MySQL HeatWave (Always Free)
module "mysql" {
  source         = "./mysql"
  compartment_id = var.OCI_TENANCY_OCID
  subnet_id      = module.networking.subnet_id
  admin_password = var.OCI_MYSQL_ADMIN_PASSWORD
  depends_on     = [module.networking]
}

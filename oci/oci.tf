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
  ingress_ports  = [22, 80, 443, 5432]
}

# 애플리케이션 인스턴스
# 용량 부족 시 Terraform Cloud 변수 변경 후 재apply:
#   OCI_APP_OCPUS=2, OCI_APP_MEMORY_GBS=12  →  실패하면
#   OCI_APP_OCPUS=1, OCI_APP_MEMORY_GBS=6   →  재시도
module "application_instance" {
  source         = "./instance"
  compartment_id = var.OCI_TENANCY_OCID
  instance_name  = "MONTY_APPLICATION_INSTANCE"
  subnet_id      = module.networking.subnet_id
  ssh_public_key = var.OCI_SSH_PUBLIC_KEY
  user_data      = templatefile("${path.module}/../scripts/oci_application_instance_userdata.sh", {
    GHCR_TOKEN = var.OCI_USERDATA_GHCR_TOKEN
  })
  ocpus         = var.OCI_APP_OCPUS
  memory_in_gbs = var.OCI_APP_MEMORY_GBS
  depends_on    = [module.networking]
}

# 데이터베이스 인스턴스
module "database_instance" {
  source         = "./instance"
  compartment_id = var.OCI_TENANCY_OCID
  instance_name  = "MONTY_DATABASE_INSTANCE"
  subnet_id      = module.networking.subnet_id
  ssh_public_key = var.OCI_SSH_PUBLIC_KEY
  user_data      = templatefile("${path.module}/../scripts/oci_database_instance_userdata.sh", {
    DB_USERNAME = var.DB_USERNAME
    DB_PASSWORD = var.DB_PASSWORD
    PG_VERSION  = 14
  })
  ocpus         = 1
  memory_in_gbs = 6
  depends_on    = [module.networking]
}

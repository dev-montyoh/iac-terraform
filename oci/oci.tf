/*
* OCI 에서 사용중인 서비스들에 대한 모듈 호출
*/

# 네트워크 (VCN, 서브넷, 보안그룹, IGW)
module "networking" {
  source            = "./networking"
  compartment_id    = var.OCI_TENANCY_OCID
  vcn_name          = "MONTY_APP"
  cidr_block        = "10.0.0.0/16"
  app_subnet_cidr   = "10.0.1.0/24"
  db_subnet_cidr    = "10.0.2.0/24"
  app_ingress_ports = [22, 80, 443]
  db_ingress_ports  = [22, 5432]
}

# 애플리케이션 인스턴스 fallback (1 OCPU / 6GB)
# 먼저 생성되어 최소 보장, 2/12 성공 시 이 블록 제거
module "application_instance_small" {
  source         = "./instance"
  compartment_id = var.OCI_TENANCY_OCID
  instance_name  = "MONTY_APPLICATION_INSTANCE_SMALL"
  subnet_id      = module.networking.app_subnet_id
  ssh_public_key = var.OCI_SSH_PUBLIC_KEY
  user_data      = templatefile("${path.module}/../scripts/oci_application_instance_userdata.sh", {
    GHCR_TOKEN = var.OCI_USERDATA_GHCR_TOKEN
  })
  ocpus         = 1
  memory_in_gbs = 6
  depends_on    = [module.networking]
}

# 애플리케이션 인스턴스 (2 OCPU / 12GB)
# small 생성 후 시도, 성공 시 small 블록 제거
module "application_instance" {
  source         = "./instance"
  compartment_id = var.OCI_TENANCY_OCID
  instance_name  = "MONTY_APPLICATION_INSTANCE"
  subnet_id      = module.networking.app_subnet_id
  ssh_public_key = var.OCI_SSH_PUBLIC_KEY
  user_data      = templatefile("${path.module}/../scripts/oci_application_instance_userdata.sh", {
    GHCR_TOKEN = var.OCI_USERDATA_GHCR_TOKEN
  })
  ocpus         = 2
  memory_in_gbs = 12
  depends_on    = [module.networking, module.application_instance_small]
}

# 데이터베이스 인스턴스
module "database_instance" {
  source         = "./instance"
  compartment_id = var.OCI_TENANCY_OCID
  instance_name  = "MONTY_DATABASE_INSTANCE"
  subnet_id      = module.networking.db_subnet_id
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

/*
* OCI 에서 사용중인 서비스들에 대한 모듈 호출
*/

# 네트워크 (VCN, 서브넷, 보안그룹, IGW)
module "networking" {
  source            = "./networking"
  compartment_id    = var.OCI_TENANCY_OCID
  vcn_name          = "APP_VPC"
  cidr_block        = "10.0.0.0/16"
  subnet_cidr       = "10.0.1.0/24"
  ingress_ports     = [22, 80, 443, 5432, 6379]
  udp_ingress_ports = [27015, 2456, 2457, 2458, 8211]
}

# 애플리케이션 인스턴스 (앱 + 데이터베이스)
module "app_instance" {
  source              = "./instance"
  compartment_id      = var.OCI_TENANCY_OCID
  instance_name       = "APPLICATION_INSTANCE"
  availability_domain = "DUoH:AP-CHUNCHEON-1-AD-1"
  image_id            = "ocid1.image.oc1.ap-chuncheon-1.aaaaaaaameprwnxnihyezzgv2j5q7u5pykdeu6pysnc2htqlih2g4nb43tca" # Canonical-Ubuntu-24.04-aarch64-2026.02.28-0
  subnet_id           = module.networking.subnet_id
  ssh_public_key      = var.OCI_SSH_PUBLIC_KEY
  user_data = templatefile("${path.module}/../scripts/oci_application_instance_userdata.sh", {
    GHCR_TOKEN = var.GHCR_TOKEN
  })
  ocpus         = 4
  memory_in_gbs = 24
  depends_on    = [module.networking]
}

# 예산 알림
module "monthly_actual_spend_budget" {
  source                = "./budget"
  amount                = 5
  compartment_id        = var.OCI_TENANCY_OCID
  display_name          = "monthly_actual_spend"
  budgets_alarm_targets = var.BUDGETS_ALARM_TARGETS
  alerts = {
    actual_spend_over_1_usd = {
      display_name = "monthly_actual_spend_over_1_usd"
      message      = "OCI actual spend exceeded 1 USD."
      threshold    = 1
    }
    actual_spend_over_5_usd = {
      display_name = "monthly_actual_spend_over_5_usd"
      message      = "OCI actual spend exceeded 5 USD."
      threshold    = 5
    }
  }
}

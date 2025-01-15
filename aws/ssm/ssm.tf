#   SSM 설정
##  Document 설정
module "ssm_document" {
  source = "./document"
}

##  SSM Maintenance Window(유지 관리 기간) 정의
module "ssm_maintenance_window" {
  source = "./maintenance_window"
}
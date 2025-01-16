#   SSM 설정
##  Document 설정
# module "ssm_document" {
#   source = "./document"
# }

##  SSM Maintenance Window(유지 관리 기간) 정의
module "ssm_maintenance_window" {
  source                          = "./maintenance_window"
  # role_arn                        = var.role_arn
  # role_name                       = var.role_name
  # ssm_document_start_arn          = module.ssm_document.ssm_document_start_arn
  # ssm_document_stop_arn           = module.ssm_document.ssm_document_stop_arn
  ec2_instance_database_server_id = var.ec2_instance_database_server_id
  # depends_on = [module.ssm_document]
}
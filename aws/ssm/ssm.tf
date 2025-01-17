##  SSM Maintenance Window(유지 관리 기간) 정의
module "ssm_maintenance_window" {
  source                          = "./maintenance_window"
  ec2_instance_database_server_id = var.ec2_instance_database_server_id
}
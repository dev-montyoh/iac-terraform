/*
* AWS SystemsManager 에서 사용중인 서비스들에 대한 모듈 호출
*/

#  SSM Maintenance Window(유지 관리 기간)
module "ssm_maintenance_window" {
  source                                       = "./maintenance_window"
  ec2_instance_id                              = var.ec2_instance_id
  iam_role_ssm_maintenance_task_manage_ec2_arn = var.iam_role_ssm_maintenance_task_manage_ec2_arn
}

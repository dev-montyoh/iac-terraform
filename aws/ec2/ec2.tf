module "security_group" {
  source = "./security_group"
  VPC_ID = var.VPC_ID
}
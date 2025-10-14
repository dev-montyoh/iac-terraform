variable "VPC_ID" { type = string }
variable "iam_instance_profile_ec2_managed_ssm_name" { type = string }
variable "AWS_EC2_SSH_ALLOWED_IPS" { type = list(string) }
variable "key_pair_name" { type = string }
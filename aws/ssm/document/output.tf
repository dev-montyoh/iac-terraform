output "ssm_document_start_arn" {
  value = aws_ssm_document.start_ec2_instances.arn
}
output "ssm_document_stop_arn" {
  value = aws_ssm_document.stop_ec2_instances.arn
}
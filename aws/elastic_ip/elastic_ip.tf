/*
* Elastic IP 설정
*/

# AWS EIP 생성
resource "aws_eip" "service_server_eip" {
}

# AWS EIP 생성 및 연결
resource "aws_eip_association" "service_server_eip_association" {
  instance_id   = var.ec2_instance_service_server_id
  allocation_id = aws_eip.service_server_eip.id
}

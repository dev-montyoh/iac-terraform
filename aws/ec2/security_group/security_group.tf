resource "aws_security_group" "security_group_ssh" {
  name = "security_group_ssh"
  description = "Allow SSH traffic"

  # 들어오는 요청에 대해 SSH요청만 허용 (보통 22포트)
  ingress {
    description = "SSH ingress"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # 나가는 응답에 대해 모두 허용
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }
}
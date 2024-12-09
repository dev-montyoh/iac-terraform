output "iam_user_info" {
  value = {
    user_name         = aws_iam_user.this.name
    email             = var.email
  }
  sensitive = true
}

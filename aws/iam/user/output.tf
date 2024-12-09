output "iam_user_info" {
  value = {
    user_name         = aws_iam_user.this.name
    password          = aws_iam_user_login_profile.this.password
    email             = var.email
  }
  sensitive = true
}

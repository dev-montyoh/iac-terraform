variable "groups" {
  type = map(object({
    name         = string
    policies_aws = list(string)
  }))
}

variable "policies_aws" {
  type = map(object({
    arn = string
  }))
}

variable "policies_custom" {
  type = map(object({
    name        = string
    description = string
    policy = object({
      Version = string
      Statement = list(object({
        Effect   = string
        Action   = list(string)
        Resource = string
      }))
    })
  }))
}

variable "users" {
  type = map(object({
    name   = string
    path   = string
    email  = string
    groups = list(string)
  }))
}

# SECRET VALUES
variable "AWS_ACCESS_KEY_ID" { type = string }
variable "AWS_SECRET_ACCESS_KEY" { type = string }
variable "VPC_ID" { type = string }
variable "BUDGETS_ALARM_TARGETS" { type = list(string) }
variable "AWS_EC2_SSH_ALLOWED_IPS" { type = list(string) }
variable "AWS_EC2_SSH_PUBLIC_KEY" { type = string }
variable "CLOUDFLARE_API_KEY" { type = string }
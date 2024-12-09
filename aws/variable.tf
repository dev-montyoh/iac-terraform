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

variable "users" {
  type = map(object({
    name   = string
    path   = string
    email  = string
    groups = list(string)
  }))
}
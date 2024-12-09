variable "name" { type = string }
variable "group_policies_aws" { type = list(string) }
variable "policies_aws" {
  type = map(object({
    arn = string
  }))
}
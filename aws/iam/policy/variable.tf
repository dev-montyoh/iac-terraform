variable "name" { type = string }
variable "description" { type = string }
variable "policy" {
  type = object({
    Version = string
    Statement = list(object({
      Effect   = string
      Action = list(string)
      Resource = string
    }))
  })
}
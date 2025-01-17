variable "name" { type = string }
variable "path" { type = string }
variable "assume_role_policy" {
  type = object({
    Version   = string
    Statement = list(object({
      Effect    = string
      Principal = object({
        Service = string
      })
      Action = string
    }))
  })
}
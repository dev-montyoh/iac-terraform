variable "amount" { type = number }
variable "compartment_id" { type = string }
variable "display_name" { type = string }
variable "budgets_alarm_targets" { type = list(string) }
variable "alerts" {
  type = map(object({
    display_name   = string
    message        = string
    threshold      = number
    threshold_type = optional(string)
    type           = optional(string)
  }))
}

variable "amount" { type = number }
variable "compartment_id" { type = string }
variable "display_name" { type = string }
variable "alert_display_name" { type = string }
variable "budgets_alarm_targets" { type = list(string) }
variable "message" { type = string }
variable "threshold" { type = number }

variable "threshold_type" {
  type    = string
  default = "ABSOLUTE"
}

variable "alert_type" {
  type    = string
  default = "ACTUAL"
}

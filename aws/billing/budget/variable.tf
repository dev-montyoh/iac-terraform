variable "name" { type = string }
variable "limit_amount" { type = string }
variable "notification_type" {
  description = "ACTUAL or FORECASTED"
  type        = string
}
variable "threshold" { type = number }
variable "BUDGETS_ALARM_TARGETS" { type = list(string) }
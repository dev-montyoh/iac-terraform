resource "aws_budgets_budget" "this" {
  name         = var.name
  budget_type  = "COST"
  limit_amount = var.limit_amount
  limit_unit   = "USD"
  time_unit    = "MONTHLY"

  notification {
    comparison_operator        = "GREATER_THAN"
    notification_type          = var.notification_type
    threshold                  = var.threshold
    threshold_type             = "PERCENTAGE"
    subscriber_email_addresses = var.BUDGETS_ALARM_TARGETS
  }
}
resource "oci_budget_budget" "monthly_actual_spend" {
  amount         = var.amount
  compartment_id = var.compartment_id
  display_name   = var.display_name
  reset_period   = "MONTHLY"
  target_type    = "COMPARTMENT"
  targets        = [var.compartment_id]
}

resource "oci_budget_alert_rule" "monthly_actual_spend_over_1_usd" {
  budget_id      = oci_budget_budget.monthly_actual_spend.id
  display_name   = var.alert_display_name
  message        = var.message
  recipients     = join(",", var.budgets_alarm_targets)
  threshold      = var.threshold
  threshold_type = var.threshold_type
  type           = var.alert_type
}

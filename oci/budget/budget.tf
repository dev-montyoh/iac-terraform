resource "oci_budget_budget" "monthly_actual_spend" {
  amount         = var.amount
  compartment_id = var.compartment_id
  display_name   = var.display_name
  reset_period   = "MONTHLY"
  target_type    = "COMPARTMENT"
  targets        = [var.compartment_id]
}

resource "oci_budget_alert_rule" "this" {
  for_each = var.alerts

  budget_id      = oci_budget_budget.monthly_actual_spend.id
  display_name   = each.value.display_name
  message        = each.value.message
  recipients     = join(",", var.budgets_alarm_targets)
  threshold      = each.value.threshold
  threshold_type = coalesce(each.value.threshold_type, "ABSOLUTE")
  type           = coalesce(each.value.type, "ACTUAL")
}

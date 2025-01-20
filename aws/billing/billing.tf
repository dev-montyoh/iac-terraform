/*
* 결제 정보 설정
*/

# 알림
## 85퍼센트 도달 알림
module "budgets_budget_85_actual" {
  source                = "./budget"
  name                  = "budgets_budget_85_actual"
  limit_amount          = "20"
  notification_type     = "ACTUAL"
  threshold             = 85
  BUDGETS_ALARM_TARGETS = var.BUDGETS_ALARM_TARGETS
}

## 100퍼센트 도달 알림
module "budgets_budget_100_actual" {
  source = "./budget"
  name                  = "budgets_budget_100_actual"
  limit_amount          = "20"
  notification_type     = "ACTUAL"
  threshold             = 100
  BUDGETS_ALARM_TARGETS = var.BUDGETS_ALARM_TARGETS
}

## 100퍼센트 도달 예정 알림
module "budgets_budget_100_forecasted" {
  source = "./budget"
  name                  = "budgets_budget_100_actual"
  limit_amount          = "20"
  notification_type     = "FORECASTED"
  threshold             = 100
  BUDGETS_ALARM_TARGETS = var.BUDGETS_ALARM_TARGETS
}
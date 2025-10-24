terraform {
  required_providers {
    cloudflare = {
      source = "cloudflare/cloudflare"
    }
  }
}

# 결제 데이터베이스
resource "cloudflare_d1_database" "d1_payment_database" {
  account_id            = var.CLOUDFLARE_ACCOUNT_ID
  name                  = "d1_payment_database"
  primary_location_hint = "APAC"

  read_replication = {
    mode = "disabled"
  }
}

# 회원 데이터베이스
resource "cloudflare_d1_database" "d1_user_database" {
  account_id            = var.CLOUDFLARE_ACCOUNT_ID
  name                  = "d1_user_database"
  primary_location_hint = "APAC"

  read_replication = {
    mode = "disabled"
  }
}

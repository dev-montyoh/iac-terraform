terraform {
  required_providers {
    cloudflare = {
      source = "cloudflare/cloudflare"
    }
  }
}

# R2 버킷 생성
resource "cloudflare_r2_bucket" "cloudflare_r2_bucket" {
  account_id = var.CLOUDFLARE_ACCOUNT_ID
  name       = var.bucket_name
  location   = "APAC"
}

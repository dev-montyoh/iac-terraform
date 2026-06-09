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

# R2 커스텀 도메인 연결
resource "cloudflare_r2_custom_domain" "cloudflare_r2_custom_domain" {
  account_id  = var.CLOUDFLARE_ACCOUNT_ID
  bucket_name = cloudflare_r2_bucket.cloudflare_r2_bucket.name
  domain      = var.domain
  zone_id     = var.zone_id
  enabled     = true

  depends_on = [cloudflare_r2_bucket.cloudflare_r2_bucket]
}

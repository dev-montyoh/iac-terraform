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

# CORS 설정 (cors_origins 지정 시에만 생성)
resource "cloudflare_r2_bucket_cors" "cloudflare_r2_bucket_cors" {
  count       = length(var.cors_origins) > 0 ? 1 : 0
  account_id  = var.CLOUDFLARE_ACCOUNT_ID
  bucket_name = cloudflare_r2_bucket.cloudflare_r2_bucket.name
  rules = [
    {
      allowed = {
        methods = ["GET", "PUT", "POST", "DELETE", "HEAD"]
        origins = var.cors_origins
        headers = ["*"]
      }
      expose_headers  = ["ETag"]
      max_age_seconds = 3600
    }
  ]

  depends_on = [cloudflare_r2_bucket.cloudflare_r2_bucket]
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

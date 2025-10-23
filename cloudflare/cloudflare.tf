terraform {
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
    }
  }
}

resource "cloudflare_dns_record" "dev_monty_web" {
  zone_id = var.CLOUDFLARE_ZONE_ID
  name    = "www.dev-monty.me"
  ttl     = 1
  type    = "A"
  comment = "www.dev_monty.me record"
  content = var.service_server_public_ip
  proxied = true
}

resource "cloudflare_r2_bucket" "cloudflare-bucket" {
  account_id = var.CLOUDFLARE_ACCOUNT_ID
  name       = "backend-api-database-bucket"
  location   = "APAC"
}
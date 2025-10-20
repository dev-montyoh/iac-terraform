terraform {
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
    }
  }
}

resource "cloudflare_dns_record" "dev_monty_web" {
  name    = "www.dev-monty.me"
  ttl     = 3600
  type    = "A"
  zone_id = var.CLOUDFLARE_ZONE_ID
  content = var.service_server_public_ip
  proxied = true
  settings = {
    ipv4_only = true
    ipv6_only = true
  }
}
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
  settings = {
    ipv4_only = true
    ipv6_only = true
  }
  tags = ["owner:dns-team"]
}
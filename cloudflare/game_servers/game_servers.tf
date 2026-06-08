# 게임 서버 DNS 레코드 (proxied=false, 게임 클라이언트 직접 연결)

resource "cloudflare_dns_record" "valheim" {
  zone_id = var.zone_id
  name    = "valheim.montyoh.dev"
  ttl     = 1
  type    = "A"
  comment = "valheim.montyoh.dev record"
  content = var.server_ip
  proxied = false
}

resource "cloudflare_dns_record" "corekeeper" {
  zone_id = var.zone_id
  name    = "corekeeper.montyoh.dev"
  ttl     = 1
  type    = "A"
  comment = "corekeeper.montyoh.dev record"
  content = var.server_ip
  proxied = false
}

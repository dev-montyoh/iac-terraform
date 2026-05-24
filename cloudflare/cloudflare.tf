terraform {
  required_providers {
    cloudflare = {
      source = "cloudflare/cloudflare"
    }
  }
}

# 도메인 설정
##  메인 도메인 - 웹 접속
resource "cloudflare_dns_record" "dev_monty_web" {
  zone_id = var.CLOUDFLARE_ZONE_ID
  name    = "www.dev-monty.me"
  ttl     = 1
  type    = "A"
  comment = "www.dev_monty.me record"
  content = var.service_server_public_ip
  proxied = true
}

##  서브 도메인 - SSH 접속
resource "cloudflare_dns_record" "dev_monty_ssh" {
  zone_id = var.CLOUDFLARE_ZONE_ID
  name    = "ssh.dev-monty.me"
  ttl     = 1
  type    = "A"
  comment = "ssh.dev-monty.me record"
  content = var.service_server_public_ip
  proxied = false
}

##  서브 도메인 - SSH 접속 (Database)
resource "cloudflare_dns_record" "dev_monty_ssh_database" {
  zone_id = var.CLOUDFLARE_ZONE_ID
  name    = "db.dev-monty.me"
  ttl     = 1
  type    = "A"
  comment = "db.dev-monty.me record"
  content = var.database_server_public_ip
  proxied = false
}

##  서브 도메인 - Frontend Payment
resource "cloudflare_dns_record" "dev_monty_web_payment" {
  zone_id = var.CLOUDFLARE_ZONE_ID
  name    = "payment.dev-monty.me"
  ttl     = 1
  type    = "A"
  comment = "payment.dev-monty.me record"
  content = var.service_server_public_ip
  proxied = true
}

# montyoh.dev 도메인 설정
##  루트 도메인 - 웹 접속
resource "cloudflare_dns_record" "montyoh_dev_root" {
  zone_id = var.CLOUDFLARE_ZONE_ID_MONTYOH_DEV
  name    = "montyoh.dev"
  ttl     = 1
  type    = "A"
  comment = "montyoh.dev record"
  content = var.service_server_public_ip
  proxied = true
}

##  서브 도메인 - 웹 접속
resource "cloudflare_dns_record" "montyoh_dev_www" {
  zone_id = var.CLOUDFLARE_ZONE_ID_MONTYOH_DEV
  name    = "www.montyoh.dev"
  ttl     = 1
  type    = "A"
  comment = "www.montyoh.dev record"
  content = var.service_server_public_ip
  proxied = true
}

##  서브 도메인 - SSH 접속
resource "cloudflare_dns_record" "montyoh_dev_ssh" {
  zone_id = var.CLOUDFLARE_ZONE_ID_MONTYOH_DEV
  name    = "ssh.montyoh.dev"
  ttl     = 1
  type    = "A"
  comment = "ssh.montyoh.dev record"
  content = var.service_server_public_ip
  proxied = false
}

##  서브 도메인 - SSH 접속 (Database)
resource "cloudflare_dns_record" "montyoh_dev_ssh_database" {
  zone_id = var.CLOUDFLARE_ZONE_ID_MONTYOH_DEV
  name    = "db.montyoh.dev"
  ttl     = 1
  type    = "A"
  comment = "db.montyoh.dev record"
  content = var.database_server_public_ip
  proxied = false
}

##  서브 도메인 - Frontend Payment
resource "cloudflare_dns_record" "montyoh_dev_payment" {
  zone_id = var.CLOUDFLARE_ZONE_ID_MONTYOH_DEV
  name    = "payment.montyoh.dev"
  ttl     = 1
  type    = "A"
  comment = "payment.montyoh.dev record"
  content = var.service_server_public_ip
  proxied = true
}

# Workers - 서버 다운 시 공사중 페이지
resource "cloudflare_workers_script" "maintenance" {
  account_id  = var.CLOUDFLARE_ACCOUNT_ID
  script_name = "maintenance"
  content     = templatefile("${path.module}/workers/maintenance.js", {
    maintenance_html = file("${path.module}/workers/maintenance.html")
  })
}

resource "cloudflare_workers_route" "montyoh_dev_maintenance" {
  zone_id     = var.CLOUDFLARE_ZONE_ID_MONTYOH_DEV
  pattern     = "*montyoh.dev/*"
  script_name = cloudflare_workers_script.maintenance.script_name
}

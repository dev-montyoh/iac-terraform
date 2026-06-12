terraform {
  required_providers {
    cloudflare = {
      source = "cloudflare/cloudflare"
    }
  }
}

# R2 버킷 - 공통 정적 파일 (static.montyoh.dev)
module "r2" {
  source                = "./r2"
  CLOUDFLARE_ACCOUNT_ID = var.CLOUDFLARE_ACCOUNT_ID
  bucket_name           = "common-static"
  domain                = "static.montyoh.dev"
  zone_id               = var.CLOUDFLARE_ZONE_ID_MONTYOH_DEV
}

# montyoh.dev 도메인 설정
##  루트 도메인 - 웹 접속
resource "cloudflare_dns_record" "montyoh_dev_root" {
  zone_id = var.CLOUDFLARE_ZONE_ID_MONTYOH_DEV
  name    = "montyoh.dev"
  ttl     = 1
  type    = "A"
  comment = "montyoh.dev record"
  content = var.oci_instance_public_ip
  proxied = true
}

##  서브 도메인 - 웹 접속
resource "cloudflare_dns_record" "montyoh_dev_www" {
  zone_id = var.CLOUDFLARE_ZONE_ID_MONTYOH_DEV
  name    = "www.montyoh.dev"
  ttl     = 1
  type    = "A"
  comment = "www.montyoh.dev record"
  content = var.oci_instance_public_ip
  proxied = true
}

##  서브 도메인 - SSH 접속
resource "cloudflare_dns_record" "montyoh_dev_ssh" {
  zone_id = var.CLOUDFLARE_ZONE_ID_MONTYOH_DEV
  name    = "ssh.montyoh.dev"
  ttl     = 1
  type    = "A"
  comment = "ssh.montyoh.dev record"
  content = var.oci_instance_public_ip
  proxied = false
}

##  서브 도메인 - Cache (Redis)
resource "cloudflare_dns_record" "montyoh_dev_cache" {
  zone_id = var.CLOUDFLARE_ZONE_ID_MONTYOH_DEV
  name    = "cache.montyoh.dev"
  ttl     = 1
  type    = "A"
  comment = "cache.montyoh.dev record"
  content = var.oci_instance_public_ip
  proxied = false
}

##  서브 도메인 - SSH 접속 (Database)
resource "cloudflare_dns_record" "montyoh_dev_ssh_database" {
  zone_id = var.CLOUDFLARE_ZONE_ID_MONTYOH_DEV
  name    = "db.montyoh.dev"
  ttl     = 1
  type    = "A"
  comment = "db.montyoh.dev record"
  content = var.oci_instance_public_ip
  proxied = false
}

##  서브 도메인 - Frontend Payment
resource "cloudflare_dns_record" "montyoh_dev_payment" {
  zone_id = var.CLOUDFLARE_ZONE_ID_MONTYOH_DEV
  name    = "payment.montyoh.dev"
  ttl     = 1
  type    = "A"
  comment = "payment.montyoh.dev record"
  content = var.oci_instance_public_ip
  proxied = true
}

##  서브 도메인 - Valheim 게임 서버
resource "cloudflare_dns_record" "montyoh_dev_valheim" {
  zone_id = var.CLOUDFLARE_ZONE_ID_MONTYOH_DEV
  name    = "valheim.montyoh.dev"
  ttl     = 1
  type    = "A"
  comment = "valheim.montyoh.dev record"
  content = var.oci_instance_public_ip
  proxied = false
}

##  서브 도메인 - Core Keeper 게임 서버
resource "cloudflare_dns_record" "montyoh_dev_corekeeper" {
  zone_id = var.CLOUDFLARE_ZONE_ID_MONTYOH_DEV
  name    = "corekeeper.montyoh.dev"
  ttl     = 1
  type    = "A"
  comment = "corekeeper.montyoh.dev record"
  content = var.oci_instance_public_ip
  proxied = false
}

##  서브 도메인 - Palworld 게임 서버
resource "cloudflare_dns_record" "montyoh_dev_palworld" {
  zone_id = var.CLOUDFLARE_ZONE_ID_MONTYOH_DEV
  name    = "palworld.montyoh.dev"
  ttl     = 1
  type    = "A"
  comment = "palworld.montyoh.dev record"
  content = var.oci_instance_public_ip
  proxied = false
}

##  서브 도메인 - Xcelerate Demo
resource "cloudflare_dns_record" "montyoh_dev_xcelerate" {
  zone_id = var.CLOUDFLARE_ZONE_ID_MONTYOH_DEV
  name    = "xcelerate.montyoh.dev"
  ttl     = 1
  type    = "A"
  comment = "xcelerate.montyoh.dev record"
  content = var.oci_instance_public_ip
  proxied = true
}

# Workers - 서버 다운 시 공사중 페이지
resource "cloudflare_workers_script" "maintenance" {
  account_id  = var.CLOUDFLARE_ACCOUNT_ID
  script_name = "maintenance"
  content = templatefile("${path.module}/workers/maintenance.js", {
    maintenance_html = file("${path.module}/workers/maintenance.html")
  })
}

resource "cloudflare_workers_route" "montyoh_dev_maintenance" {
  zone_id = var.CLOUDFLARE_ZONE_ID_MONTYOH_DEV
  pattern = "*montyoh.dev/*"
  script  = cloudflare_workers_script.maintenance.script_name
}

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

##  서브 도메인 - R2 버킷 접근 도메인
# resource "cloudflare_dns_record" "dev_monty_cdn" {
#   zone_id = var.CLOUDFLARE_ZONE_ID
#   name    = "cdn.dev-monty.me"
#   type    = "CNAME"
#   comment = "cdn.dev-monty.me record"
#   content = "r2.cloudflarestorage.com"
#   ttl     = 1
#   proxied = true
# }

##  R2 버킷 생성
### Content 
module "r2" {
  source                = "./r2"
  CLOUDFLARE_ACCOUNT_ID = var.CLOUDFLARE_ACCOUNT_ID
  bucket_name           = "content"
}

##  서브도메인 - Content R2 버킷 연결
resource "cloudflare_r2_custom_domain" "dev_monty_cdn_r2" {
  account_id  = var.CLOUDFLARE_ACCOUNT_ID
  bucket_name = module.r2.bucket_name
  domain      = cloudflare_dns_record.dev_monty_cdn.name
  enabled     = true
  zone_id     = var.CLOUDFLARE_ZONE_ID
  depends_on = [module.r2, cloudflare_dns_record.dev_monty_cdn]
}
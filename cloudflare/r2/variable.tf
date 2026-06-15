variable "CLOUDFLARE_ACCOUNT_ID" { type = string }
variable "bucket_name" { type = string }
variable "domain" { type = string }
variable "zone_id" { type = string }
variable "cors_origins" {
  type    = list(string)
  default = []
}

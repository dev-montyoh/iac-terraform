variable "CLOUDFLARE_ACCOUNT_ID" { type = string }
variable "bucket_name" { type = string }
variable "domain" {
  type    = string
  default = ""
}
variable "zone_id" {
  type    = string
  default = ""
}
variable "cors_origins" {
  type    = list(string)
  default = []
}

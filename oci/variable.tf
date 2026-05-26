variable "OCI_TENANCY_OCID"        { type = string }
variable "OCI_SSH_PUBLIC_KEY"      { type = string }
variable "OCI_USERDATA_GHCR_TOKEN" { type = string }
variable "DB_USERNAME"             { type = string }
variable "DB_PASSWORD"             { type = string }

# 용량 부족 시 2/12 → 1/6 으로 변경 후 재apply
variable "OCI_APP_OCPUS" {
  type    = number
  default = 2
}

variable "OCI_APP_MEMORY_GBS" {
  type    = number
  default = 12
}

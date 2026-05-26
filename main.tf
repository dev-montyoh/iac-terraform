terraform {
  required_providers {
    # Amazon Web Services
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "5.11.0"
    }
    # Oracle Cloud Infrastructure
    oci = {
      source  = "oracle/oci"
      version = "~> 6.0"
    }
  }
}

# AWS
provider "aws" {
  region     = "ap-northeast-2"
  access_key = var.AWS_ACCESS_KEY_ID
  secret_key = var.AWS_SECRET_ACCESS_KEY
}

provider "cloudflare" {
  email     = var.CLOUDFLARE_EMAIL
  api_token = var.CLOUDFLARE_API_TOKEN
}


module "aws" {
  source                      = "./aws"
  groups                      = var.groups
  policies_aws                = var.policies_aws
  policies_custom             = var.policies_custom
  users                       = var.users
  BUDGETS_ALARM_TARGETS       = var.BUDGETS_ALARM_TARGETS
  AWS_SSH_PUBLIC_KEY          = var.AWS_EC2_SSH_PUBLIC_KEY
  AWS_EC2_USERDATA_GHCR_TOKEN = var.AWS_EC2_USERDATA_GHCR_TOKEN
  DB_USERNAME                 = var.DB_USERNAME
  DB_PASSWORD                 = var.DB_PASSWORD
}

provider "oci" {
  tenancy_ocid = var.OCI_TENANCY_OCID
  user_ocid    = var.OCI_USER_OCID
  fingerprint  = var.OCI_FINGERPRINT
  private_key  = var.OCI_PRIVATE_KEY
  region       = var.OCI_REGION
}

module "oci" {
  source                  = "./oci"
  OCI_TENANCY_OCID        = var.OCI_TENANCY_OCID
  OCI_SSH_PUBLIC_KEY      = var.AWS_EC2_SSH_PUBLIC_KEY
  OCI_USERDATA_GHCR_TOKEN = var.AWS_EC2_USERDATA_GHCR_TOKEN
  DB_USERNAME             = var.DB_USERNAME
  DB_PASSWORD             = var.DB_PASSWORD
  OCI_APP_OCPUS           = var.OCI_APP_OCPUS
  OCI_APP_MEMORY_GBS      = var.OCI_APP_MEMORY_GBS
}

module "cloudflare" {
  source                         = "./cloudflare"
  service_server_public_ip       = module.aws.service_server_public_ip
  database_server_public_ip      = module.aws.database_server_public_ip
  depends_on                     = [module.aws]
  CLOUDFLARE_ZONE_ID             = var.CLOUDFLARE_ZONE_ID
  CLOUDFLARE_ZONE_ID_MONTYOH_DEV = var.CLOUDFLARE_ZONE_ID_MONTYOH_DEV
  CLOUDFLARE_ACCOUNT_ID          = var.CLOUDFLARE_ACCOUNT_ID
}

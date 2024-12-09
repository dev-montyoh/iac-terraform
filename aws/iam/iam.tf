module "group" {
  source             = "./group"
  for_each           = var.groups
  name               = each.value.name
  group_policies_aws = each.value.policies_aws
  policies_aws       = var.policies_aws
}

module "user" {
  source   = "./user"
  for_each = var.users
  name     = each.value.name
  path     = each.value.path
  email    = each.value.email
  groups   = each.value.groups
}
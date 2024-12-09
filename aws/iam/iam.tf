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

resource "null_resource" "user_info_to_csv" {
  for_each = module.user
  provisioner "local-exec" {
    command = "echo username,Password >> $user_name.csv\necho $user_name,$password >> $user_name.csv"

    environment = {
      user_name = each.value.iam_user_info.user_name
      password  = each.value.iam_user_info.password
      email     = each.value.iam_user_info.email
    }
  }
  depends_on = [module.user.iam_user_info]
}

resource "null_resource" "send_email_to_user" {
  for_each = module.user
  provisioner "local-exec" {
    command = "echo \"This is mail of AWS IAM\" | mutt -s \"monmon51725@gmail.com\" -a $user_name.csv -- $email"

    environment = {
      user_name = each.value.iam_user_info.user_name
      email     = each.value.iam_user_info.email
    }
  }

  depends_on = [
    null_resource.user_info_to_csv
  ]
}
groups = {
  "Admin" = {
    name         = "Admin"
    policies_aws = [
      "IAMFullAccess"
    ]
  },
  "Developers" = {
    name         = "Developers"
    policies_aws = [
      "IAMReadOnlyAccess",
      "AmazonEC2FullAccess",
      "AmazonRoute53FullAccess"
    ]
  }
}
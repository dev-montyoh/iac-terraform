groups = {
  "Developers" = {
    name         = "Developer"
    policies_aws = [
      "IAMReadOnlyAccess",
      "AmazonEC2FullAccess",
      "AmazonRoute53FullAccess",
      "IAMUserChangePassword"
    ]
  },
  "Guest" = {
    name         = "Guest",
    policies_aws = [
      "IAMReadOnlyAccess",
      "AmazonEC2ReadOnlyAccess",
      "AmazonRoute53ReadOnlyAccess",
      "IAMUserChangePassword"
    ]
  }
}
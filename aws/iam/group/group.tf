resource "aws_iam_group" "this" {
  name = var.name
}

resource "aws_iam_group_policy_attachment" "group_policy_aws" {
  count      = length(var.group_policies_aws)
  group      = aws_iam_group.this.name
  policy_arn = lookup(var.policies_aws, var.group_policies_aws[count.index]).arn
}
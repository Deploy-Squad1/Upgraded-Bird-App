resource "aws_iam_group" "deploy_squad" {
  name = "deploy_squad"
}

resource "aws_iam_group_policy_attachment" "power_user_attach" {
  group      = "deploy_squad"
  policy_arn = "arn:aws:iam::aws:policy/PowerUserAccess"
}

resource "aws_iam_user" "users" {
  for_each = var.usernames
  name     = each.value
}

resource "aws_iam_user_group_membership" "users_in_deploy_squad" {
  for_each = var.usernames
  user     = aws_iam_user.users[each.value].name
  groups   = [aws_iam_group.deploy_squad.name]
}

resource "aws_iam_access_key" "users_keys" {
  for_each = var.usernames
  user     = aws_iam_user.users[each.value].name
}

resource "aws_iam_group_policy_attachment" "allow_password_change" {
  group      = aws_iam_group.deploy_squad.name
  policy_arn = "arn:aws:iam::aws:policy/IAMUserChangePassword"
}

resource "aws_iam_user_login_profile" "users_logins" {
  for_each                = var.usernames
  user                    = aws_iam_user.users[each.value].name
  password_reset_required = true
}

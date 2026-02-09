resource "aws_iam_group" "deploy_squad" {
  name = "deploy_squad"
}

resource "aws_iam_group_policy_attachment" "power_user_attach" {
  group      = "deploy_squad"
  policy_arn = "arn:aws:iam::aws:policy/PowerUserAccess"
}
variable "user_names" {
  type=set(string)
  default=["marian", "daria", "pavlo"]
}

resource "aws_iam_user" "users" {
  for_each = var.user_names
  name     = each.value
}

resource "aws_iam_user_group_membership" "users_in_deploy_squad" {
  for_each = var.user_names
  user     = aws_iam_user.users[each.value].name
  groups   = [aws_iam_group.deploy_squad.name]
}

resource "aws_iam_access_key" "users_keys" {
  for_each = var.user_names
  user     = aws_iam_user.users[each.value].name
}
resource "aws_iam_group_policy_attachment" "allow_password_change" {
  group      = aws_iam_group.deploy_squad.name
  policy_arn = "arn:aws:iam::aws:policy/IAMUserChangePassword"
}

resource "aws_iam_user_login_profile" "users_logins" {
  for_each = var.user_names
  user = aws_iam_user.users[each.value].name
  password_reset_required = true
}
resource "aws_iam_role" "ssm_role" {
  name = "ssm-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ssm_policy" {
  role       = aws_iam_role.ssm_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "ssm_profile" {
  name = "ssm-profile"
  role = aws_iam_role.ssm_role.name
}
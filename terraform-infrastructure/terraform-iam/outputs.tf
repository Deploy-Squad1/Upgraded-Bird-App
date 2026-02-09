output "user_credentials" {
  value = {
    for k, v in aws_iam_access_key.users_keys : k => {
      access_key = v.id
      secret_key = v.secret
    }
  }
  sensitive = true
}

output "console_passwords" {
  value = {
    for k, v in aws_iam_user_login_profile.users_logins : k => v.password
  }
  sensitive = true
}
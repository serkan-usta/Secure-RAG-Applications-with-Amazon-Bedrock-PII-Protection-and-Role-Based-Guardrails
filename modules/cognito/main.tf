resource "aws_cognito_user_pool" "this" {
  name = "${var.prefix}-user-pool"

  password_policy {
    minimum_length    = 8
    require_uppercase = true
    require_lowercase = true
    require_numbers   = true
    require_symbols   = true
  }

  auto_verified_attributes = ["email"]
}

resource "aws_cognito_user_pool_client" "this" {
  name         = "${var.prefix}-app-client"
  user_pool_id = aws_cognito_user_pool.this.id

  explicit_auth_flows = [
    "ALLOW_USER_PASSWORD_AUTH",
    "ALLOW_REFRESH_TOKEN_AUTH"
  ]
}

resource "aws_cognito_user_group" "groups" {
  for_each     = var.create_groups ? toset(var.groups) : toset([])
  name         = each.value
  user_pool_id = aws_cognito_user_pool.this.id
  description  = "${each.value} access group"
}

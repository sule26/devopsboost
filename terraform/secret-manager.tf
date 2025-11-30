resource "random_password" "grafana_admin_password" {
  length  = 15
  special = true
}

resource "aws_secretsmanager_secret" "grafana" {
  name                    = "grafana"
  recovery_window_in_days = 0

}

resource "aws_secretsmanager_secret_version" "grafana" {
  secret_id = aws_secretsmanager_secret.grafana.id

  secret_string = jsonencode({
    "admin-user"     = "admin"
    "admin-password" = random_password.grafana_admin_password.result
  })
}

resource "aws_secretsmanager_secret" "crossplane" {
  name                    = "crossplane"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "crossplane_creds" {
  secret_id = aws_secretsmanager_secret.crossplane.id

  secret_string = jsonencode({
    "aws-access-key-id"     = aws_iam_access_key.crossplane.id
    "aws-secret-access-key" = aws_iam_access_key.crossplane.secret
  })
}

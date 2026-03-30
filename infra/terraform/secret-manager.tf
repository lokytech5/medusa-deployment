resource "aws_secretsmanager_secret" "medusa_secrets" {
  name                    = "medusa-secretss"
  description             = "Secrets for Medusa Application"
  recovery_window_in_days = 0

  tags = {
    Name = "medusa-secrets"
  }
}

resource "aws_secretsmanager_secret_version" "medusa_secrets_value" {
  secret_id = aws_secretsmanager_secret.medusa_secrets.id

  secret_string = jsonencode({
    DATABASE_URL  = "postgres://medusa_user:admin123@${aws_db_instance.medusa_postgres_db.address}:5432/medusa_db"
    JWT_SECRET    = "supersecretjwt"
    COOKIE_SECRET = "supersecretcookie"
  })
}

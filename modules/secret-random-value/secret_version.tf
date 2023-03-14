## Lambda refuses to rotate non-existing secret so it is some temporary.

resource "aws_secretsmanager_secret_version" "this" {
  secret_id     = aws_secretsmanager_secret.this.id
  secret_string = "{}"

  lifecycle {
    ignore_changes = [
      secret_string
    ]
  }
}

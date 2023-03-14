resource "aws_secretsmanager_secret" "this" {
  name = var.name

  recovery_window_in_days = var.recovery_window_in_days

  tags = {
    Name   = var.name
    Object = "aws_secretsmanager_secret.this"
    Module = path.module
  }
}

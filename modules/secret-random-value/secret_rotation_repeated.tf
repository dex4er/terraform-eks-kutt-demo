## Rotation policy for repeated rotation

resource "aws_secretsmanager_secret_rotation" "repeated" {
  count = var.rotate_after_days > 0 ? 1 : 0

  secret_id           = aws_secretsmanager_secret.this.id
  rotation_lambda_arn = module.lambda.lambda_function_arn

  rotation_rules {
    automatically_after_days = var.rotate_after_days
  }

  depends_on = [
    aws_secretsmanager_secret_version.this,
    module.lambda,
  ]
}

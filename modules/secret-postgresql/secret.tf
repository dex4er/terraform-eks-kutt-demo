resource "aws_secretsmanager_secret" "this" {
  name = var.secret_name

  recovery_window_in_days = var.recovery_window_in_days

  tags = {
    Name   = var.secret_name
    Object = "aws_secretsmanager_secret.this"
    Module = path.module
  }
}

## Rotation policy for repeated rotation

resource "aws_secretsmanager_secret_rotation" "this" {
  secret_id           = aws_secretsmanager_secret.this.id
  rotation_lambda_arn = module.lambda_secret_rotate.lambda_function_arn

  rotation_rules {
    automatically_after_days = var.rotate_after_days
  }
}

## Initial secret

resource "aws_secretsmanager_secret_version" "this" {
  secret_id = aws_secretsmanager_secret.this.id

  secret_string = jsonencode(
    {
      dbClusterIdentifier = var.cluster_id
      dbname              = var.cluster_database_name
      engine              = "postgres"
      host                = var.cluster_endpoint
      port                = var.cluster_port
      username            = var.cluster_master_username
      password            = var.cluster_master_password
    }
  )

  lifecycle {
    ignore_changes = [
      secret_string
    ]
  }
}

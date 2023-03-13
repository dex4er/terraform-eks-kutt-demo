output "secret_arn" {
  description = "ARN of the secret with PostgreSQL credentials."
  value       = aws_secretsmanager_secret.this.arn
}

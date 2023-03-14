output "arn" {
  description = "ARN of the generated secret"
  value       = aws_secretsmanager_secret.this.arn
}

module "lambda" {
  ## https://github.com/terraform-aws-modules/terraform-aws-lambda
  source  = "terraform-aws-modules/lambda/aws"
  version = "4.12.1"

  function_name = "${var.name}-rotate"
  description   = "Rotate Secrets Manager random value"
  runtime       = "nodejs16.x"
  handler       = "index.handler"

  publish = true

  create_package         = !var.install_deployment_zip
  source_path            = var.install_deployment_zip ? null : "${path.module}/lambda/index.js"
  local_existing_package = var.install_deployment_zip ? "${path.module}/lambda/deployment.zip" : null

  environment_variables = {
    SECRETS_MANAGER_ENDPOINT = coalesce(var.aws_secretsmanager_endpoint, "https://secretsmanager.${var.region}.amazonaws.com")
    EXCLUDE_CHARACTERS       = var.exclude_characters
    PASSWORD_LENGTH          = tostring(var.password_length)
    ROTATE_AFTER_DAYS        = tostring(var.rotate_after_days)
  }

  policy_path = "/"
  role_path   = "/"

  attach_policy_json = true
  policy_json = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Sid" : "PutSecretValue",
          "Effect" : "Allow",
          "Action" : [
            "secretsmanager:CancelRotateSecret",
            "secretsmanager:DescribeSecret",
            "secretsmanager:GetSecretValue",
            "secretsmanager:PutSecretValue",
            "secretsmanager:UpdateSecretVersionStage"
          ],
          "Resource" : aws_secretsmanager_secret.this.arn
        },
        {
          "Sid" : "GetRandomPassword",
          "Effect" : "Allow",
          "Action" : [
            "secretsmanager:GetRandomPassword"
          ],
          "Resource" : "*"
        },
        {
          "Sid" : "CreateNetworkInterface",
          "Action" : [
            "ec2:CreateNetworkInterface",
            "ec2:DeleteNetworkInterface",
            "ec2:DescribeNetworkInterfaces",
            "ec2:DetachNetworkInterface"
          ],
          "Resource" : "*",
          "Effect" : "Allow"
        }
      ]
    }
  )

  allowed_triggers = {
    SecretsManagerAccess = {
      principal  = "secretsmanager.amazonaws.com"
      action     = "lambda:InvokeFunction"
      source_arn = aws_secretsmanager_secret.this.arn
    }
  }

  tags = {
    Name   = "${var.name}-rotate-secret"
    Object = "module.lambda"
    Module = path.module
  }
}

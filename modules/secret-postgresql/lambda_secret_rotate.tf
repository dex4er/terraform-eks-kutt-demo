module "lambda_secret_rotate" {
  ## https://github.com/terraform-aws-modules/terraform-aws-lambda
  source  = "terraform-aws-modules/lambda/aws"
  version = "4.12.1"

  function_name = "${var.secret_name}-rotate"
  description   = "Rotate Secrets Manager PostgreSQL password"
  runtime       = "python3.9"
  handler       = "lambda_function.lambda_handler"

  publish = true

  create_package = !var.install_deployment_zip

  local_existing_package = var.install_deployment_zip ? "${path.module}/lambda/deployment.zip" : null

  source_path = var.install_deployment_zip ? null : [
    "${path.module}/lambda/lambda_function.py",
    {
      pip_requirements = "${path.module}/lambda/requirements.txt"
      patterns = [
        "!.*\\.dist-info/.*",
      ]
    },
    {
      commands = [
        "cd $(mktemp -d)",
        "docker run --rm -w /var/task -v $(pwd):/var/task public.ecr.aws/sam/build-python3.9:${var.secret_name}-rotate bash -c 'cp /lib64/liblber-2.4.so.2 /lib64/libldap_r-2.4.so.2 /lib64/libnss3.so /lib64/libpq.so.5 /lib64/libsasl2.so.3 /lib64/libsmime3.so /lib64/libssl3.so .'",
        ":zip",
      ]
    }
  ]

  build_in_docker   = true
  docker_file       = "${path.module}/lambda/Dockerfile"
  docker_build_root = "${path.module}/lambda"
  docker_image      = "public.ecr.aws/sam/build-python3.9:${var.secret_name}-rotate"

  environment_variables = {
    SECRETS_MANAGER_ENDPOINT = "https://secretsmanager.${var.region}.amazonaws.com"
    EXCLUDE_CHARACTERS       = "!\"#$%&'()*+,/:;<=>?@[\\]^`{|}"
  }

  vpc_subnet_ids         = var.vpc_private_subnet_ids
  vpc_security_group_ids = [module.sg_lambda_secret_rotate.security_group_id]
  attach_network_policy  = true

  policy_path = "/"
  role_path   = "/"

  attach_policy_json = true
  policy_json = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Sid" : "AllowPutSecretValue",
          "Effect" : "Allow",
          "Action" : [
            "secretsmanager:CancelRotateSecret",
            "secretsmanager:DescribeSecret",
            "secretsmanager:GetSecretValue",
            "secretsmanager:PutSecretValue",
            "secretsmanager:UpdateSecretVersionStage"
          ],
          "Resource" : aws_secretsmanager_secret.this.arn,
          "Condition" : {
            "StringEquals" : {
              "secretsmanager:resource/AllowRotationLambdaArn" : "arn:aws:lambda:${var.region}:${var.account_id}:function:${var.secret_name}-rotate"
            }
          },
        },
        {
          "Sid" : "AllowGetRandomPassword",
          "Effect" : "Allow",
          "Action" : [
            "secretsmanager:GetRandomPassword"
          ],
          "Resource" : "*"
        },
        {
          "Sid" : "AllowCreateNetworkInterface",
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
    Name   = "${var.secret_name}-rotate"
    Object = "module.lambda_secret_rotate"
    Module = path.module
  }
}

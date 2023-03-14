# secret-random-value

Terraform module for a secret with a generated random value.

The new secret will have a temporary `{}`` value and it will be immediately
refreshed with a random value.

## Usage

```terraform
provider "aws" {
  region = "us-east-1"
}

module "secret_random_value" {
  source = "./modules/secret-random-value/"

  region = "us-east-1"

  name = "secret-name"

  recovery_window_in_days = 7
}
```

<!-- BEGIN_TF_DOCS -->

## Requirements

| Name                                                                     | Version           |
| ------------------------------------------------------------------------ | ----------------- |
| <a name="requirement_terraform"></a> [terraform](#requirement_terraform) | >= 1.3.0, < 1.4.0 |
| <a name="requirement_aws"></a> [aws](#requirement_aws)                   | >= 4.0.0, < 5.0.0 |

## Providers

| Name                                             | Version           |
| ------------------------------------------------ | ----------------- |
| <a name="provider_aws"></a> [aws](#provider_aws) | >= 4.0.0, < 5.0.0 |

## Modules

| Name                                                  | Source                           | Version |
| ----------------------------------------------------- | -------------------------------- | ------- |
| <a name="module_lambda"></a> [lambda](#module_lambda) | terraform-aws-modules/lambda/aws | 4.7.2   |

## Resources

| Name                                                                                                                                                      | Type     |
| --------------------------------------------------------------------------------------------------------------------------------------------------------- | -------- |
| [aws_secretsmanager_secret.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret)                       | resource |
| [aws_secretsmanager_secret_rotation.repeated](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_rotation) | resource |
| [aws_secretsmanager_secret_rotation.single](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_rotation)   | resource |
| [aws_secretsmanager_secret_version.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_version)       | resource |

## Inputs

| Name                                                                                                               | Description                                                                                                                                                                  | Type     | Default                              | Required |
| ------------------------------------------------------------------------------------------------------------------ | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------- | ------------------------------------ | :------: |
| <a name="input_aws_secretsmanager_endpoint"></a> [aws_secretsmanager_endpoint](#input_aws_secretsmanager_endpoint) | Secrets Manager service endpoint URL.                                                                                                                                        | `string` | `""`                                 |    no    |
| <a name="input_exclude_characters"></a> [exclude_characters](#input_exclude_characters)                            | A string of the characters that you don't want in the password; default: all punctuation characters except `+` and `/`.                                                      | `string` | `"!\"#$%&'()*,-.:;<=>?@[\\]^_`{\|}~" |    no    |
| <a name="input_install_deployment_zip"></a> [install_deployment_zip](#input_install_deployment_zip)                | Controls whether existing deployment.zip package for Lambda should be used instead packing source files.                                                                     | `bool`   | `true`                               |    no    |
| <a name="input_name"></a> [name](#input_name)                                                                      | Name of the secret                                                                                                                                                           | `string` | n/a                                  |   yes    |
| <a name="input_password_length"></a> [password_length](#input_password_length)                                     | The length of the password; default: 32 characters.                                                                                                                          | `number` | `32`                                 |    no    |
| <a name="input_recovery_window_in_days"></a> [recovery_window_in_days](#input_recovery_window_in_days)             | Number of days that AWS Secrets Manager waits before it can delete the secret. This value can be 0 to force deletion without recovery or range from 7 to 30 days. Default: 7 | `number` | `7`                                  |    no    |
| <a name="input_region"></a> [region](#input_region)                                                                | AWS region for main resources.                                                                                                                                               | `string` | n/a                                  |   yes    |
| <a name="input_rotate_after_days"></a> [rotate_after_days](#input_rotate_after_days)                               | Rotate password after number of days. Zero disables rotation immediately.                                                                                                    | `number` | `0`                                  |    no    |

## Outputs

| Name                                         | Description                 |
| -------------------------------------------- | --------------------------- |
| <a name="output_arn"></a> [arn](#output_arn) | ARN of the generated secret |

<!-- END_TF_DOCS -->

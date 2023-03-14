# secret-postgresql

Handles rotation of the Secrets Manager secret for RDS PostgreSQL.

<!-- BEGIN_TF_DOCS -->

## Requirements

| Name                                                                     | Version           |
| ------------------------------------------------------------------------ | ----------------- |
| <a name="requirement_terraform"></a> [terraform](#requirement_terraform) | >= 1.2.0, < 1.4.0 |
| <a name="requirement_aws"></a> [aws](#requirement_aws)                   | >= 4.0.0, < 5.0.0 |

## Providers

| Name                                             | Version           |
| ------------------------------------------------ | ----------------- |
| <a name="provider_aws"></a> [aws](#provider_aws) | >= 4.0.0, < 5.0.0 |

## Modules

| Name                                                                                                     | Source                                   | Version |
| -------------------------------------------------------------------------------------------------------- | ---------------------------------------- | ------- |
| <a name="module_lambda_secret_rotate"></a> [lambda_secret_rotate](#module_lambda_secret_rotate)          | terraform-aws-modules/lambda/aws         | 4.2.1   |
| <a name="module_sg_lambda_secret_rotate"></a> [sg_lambda_secret_rotate](#module_sg_lambda_secret_rotate) | terraform-aws-modules/security-group/aws | 4.16.0  |

## Resources

| Name                                                                                                                                                  | Type     |
| ----------------------------------------------------------------------------------------------------------------------------------------------------- | -------- |
| [aws_secretsmanager_secret.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret)                   | resource |
| [aws_secretsmanager_secret_rotation.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_rotation) | resource |
| [aws_secretsmanager_secret_version.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_version)   | resource |

## Inputs

| Name                                                                                                         | Description                                                                                                                                                                  | Type           | Default | Required |
| ------------------------------------------------------------------------------------------------------------ | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------------- | ------- | :------: |
| <a name="input_account_id"></a> [account_id](#input_account_id)                                              | AWS Account ID for main resources.                                                                                                                                           | `number`       | n/a     |   yes    |
| <a name="input_cluster_database_name"></a> [cluster_database_name](#input_cluster_database_name)             | Name for an automatically created database on cluster creation.                                                                                                              | `string`       | n/a     |   yes    |
| <a name="input_cluster_endpoint"></a> [cluster_endpoint](#input_cluster_endpoint)                            | Writer endpoint for the cluster.                                                                                                                                             | `string`       | n/a     |   yes    |
| <a name="input_cluster_id"></a> [cluster_id](#input_cluster_id)                                              | The RDS Cluster Identifier.                                                                                                                                                  | `string`       | n/a     |   yes    |
| <a name="input_cluster_master_password"></a> [cluster_master_password](#input_cluster_master_password)       | The database master password.                                                                                                                                                | `string`       | n/a     |   yes    |
| <a name="input_cluster_master_username"></a> [cluster_master_username](#input_cluster_master_username)       | The database master username.                                                                                                                                                | `string`       | n/a     |   yes    |
| <a name="input_cluster_port"></a> [cluster_port](#input_cluster_port)                                        | The database port.                                                                                                                                                           | `string`       | n/a     |   yes    |
| <a name="input_install_deployment_zip"></a> [install_deployment_zip](#input_install_deployment_zip)          | Controls whether existing deployment.zip package for Lambda should be used instead packing source files.                                                                     | `bool`         | `true`  |    no    |
| <a name="input_recovery_window_in_days"></a> [recovery_window_in_days](#input_recovery_window_in_days)       | Number of days that AWS Secrets Manager waits before it can delete the secret. This value can be 0 to force deletion without recovery or range from 7 to 30 days. Default: 7 | `number`       | `7`     |    no    |
| <a name="input_region"></a> [region](#input_region)                                                          | AWS region for main resources.                                                                                                                                               | `string`       | n/a     |   yes    |
| <a name="input_rotate_after_days"></a> [rotate_after_days](#input_rotate_after_days)                         | Rotate password after number of days. Zero disables rotation immediately.                                                                                                    | `number`       | `1000`  |    no    |
| <a name="input_secret_name"></a> [secret_name](#input_secret_name)                                           | Name prefix of the resources for this project.                                                                                                                               | `string`       | n/a     |   yes    |
| <a name="input_vpc_database_subnet_cidrs"></a> [vpc_database_subnet_cidrs](#input_vpc_database_subnet_cidrs) | List of subnet CIDRs where database is in the VPC.                                                                                                                           | `list(string)` | n/a     |   yes    |
| <a name="input_vpc_id"></a> [vpc_id](#input_vpc_id)                                                          | ID of the VPC.                                                                                                                                                               | `string`       | n/a     |   yes    |
| <a name="input_vpc_private_subnet_ids"></a> [vpc_private_subnet_ids](#input_vpc_private_subnet_ids)          | List of subnet ids when Lambda Function should run in the VPC.                                                                                                               | `list(string)` | n/a     |   yes    |

## Outputs

| Name                                                              | Description                                    |
| ----------------------------------------------------------------- | ---------------------------------------------- |
| <a name="output_secret_arn"></a> [secret_arn](#output_secret_arn) | ARN of the secret with PostgreSQL credentials. |

<!-- END_TF_DOCS -->

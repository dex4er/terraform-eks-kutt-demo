## IRSA for external-secrets.io

module "irsa_external_secrets" {
  ## https://github.com/terraform-aws-modules/terraform-aws-iam/tree/master/modules/iam-role-for-service-accounts-eks
  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version = "5.12.0"

  role_name          = "${module.eks.cluster_name}-irsa-external-secrets"
  role_path          = "/"
  role_description   = "External Secrets IAM role"
  policy_name_prefix = "${module.eks.cluster_name}-irsa-"

  attach_external_secrets_policy = true

  external_secrets_ssm_parameter_arns = ["arn:aws:ssm:${var.region}:${var.account_id}:parameter/${var.name}-*"]

  oidc_providers = {
    (module.eks.cluster_name) = {
      provider_arn               = module.eks.oidc_provider_arn
      namespace_service_accounts = ["external-secrets:external-secrets"]
    }
  }

  tags = {
    Name   = "${var.name}-irsa-external-secrets"
    Object = "module.irsa_external_secrets"
  }
}

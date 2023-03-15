## IRSA for external-dns

module "irsa_external_dns" {
  ## https://github.com/terraform-aws-modules/terraform-aws-iam/tree/master/modules/iam-role-for-service-accounts-eks
  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version = "5.12.0"

  role_name          = "${module.eks.cluster_name}-irsa-external-dns"
  role_path          = "/"
  role_description   = "ExternalDNS IAM role"
  policy_name_prefix = "${module.eks.cluster_name}-irsa-"

  attach_external_dns_policy = true

  external_dns_hosted_zone_arns = [data.aws_route53_zone.this.arn]

  oidc_providers = {
    (module.eks.cluster_name) = {
      provider_arn               = module.eks.oidc_provider_arn
      namespace_service_accounts = ["external-dns:external-dns"]
    }
  }

  tags = {
    Name   = "${var.name}-irsa-external-dns"
    Object = "module.irsa_external_dns"
  }
}

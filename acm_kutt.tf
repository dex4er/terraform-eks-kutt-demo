module "acm_kutt" {
  ## https://github.com/terraform-aws-modules/terraform-aws-acm
  source  = "terraform-aws-modules/acm/aws"
  version = "4.3.2"

  domain_name = "kutt.${var.domain_name}"
  zone_id     = local.domain_zone

  wait_for_validation = true

  tags = {
    Name   = "kutt.${var.domain_name}"
    Object = "module.acm_kutt"
  }
}

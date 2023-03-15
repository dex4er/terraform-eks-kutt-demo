data "aws_route53_zone" "this" {
  name = var.domain_name
}

locals {
  domain_zone = data.aws_route53_zone.this.zone_id
}

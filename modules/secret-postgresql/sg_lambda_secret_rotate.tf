module "sg_lambda_secret_rotate" {
  ## https://github.com/terraform-aws-modules/terraform-aws-security-group
  source  = "terraform-aws-modules/security-group/aws"
  version = "4.17.1"

  use_name_prefix = false
  name            = "${var.secret_name}-secret-rotate"

  description = "Security group for VPC endpoint access"
  vpc_id      = var.vpc_id

  egress_with_cidr_blocks = [
    {
      description = "All HTTPS egress"
      rule        = "https-443-tcp"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      description = "PostgreSQL in database subnet egress"
      rule        = "postgresql-tcp"
      cidr_blocks = join(",", var.vpc_database_subnet_cidrs)
    },
  ]

  tags = {
    Name   = "${var.secret_name}-secret-rotate"
    Object = "module.sg_lambda_secret_rotate"
    Module = path.module
  }
}

## Security Group for a cluster

module "sg_redis" {
  ## https://github.com/terraform-aws-modules/terraform-aws-security-group
  source  = "terraform-aws-modules/security-group/aws"
  version = "4.17.1"

  name = "${var.name}-redis"

  use_name_prefix = false

  description = "Redis cluster security group"
  vpc_id      = local.vpc_id

  ingress_with_source_security_group_id = [
    {
      description              = "Node groups to Redis cluster"
      rule                     = "redis-tcp"
      source_security_group_id = module.sg_node_group.security_group_id
    },
  ]

  tags = {
    Name   = "${var.name}-cluster"
    Object = "module.sg_redis"
  }
}

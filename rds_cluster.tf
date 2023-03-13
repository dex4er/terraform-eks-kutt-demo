module "rds_cluster" {
  ## https://github.com/terraform-aws-modules/terraform-aws-rds-aurora
  source  = "terraform-aws-modules/rds-aurora/aws"
  version = "7.7.0"

  name = "${var.name}-postgresql"

  engine            = "aurora-postgresql"
  engine_mode       = "provisioned"
  engine_version    = "12.13"
  storage_encrypted = true

  database_name          = "kutt"
  master_username        = "master"
  create_random_password = true

  vpc_id  = local.vpc_id
  subnets = module.vpc.database_subnets

  create_security_group          = true
  security_group_use_name_prefix = false

  allowed_cidr_blocks = var.cluster_in_private_subnet ? module.vpc.private_subnets_cidr_blocks : module.vpc.public_subnets_cidr_blocks

  monitoring_interval = 60

  apply_immediately   = true
  skip_final_snapshot = true

  instance_class = "db.t3.medium"

  ## defaults are fine
  create_db_cluster_parameter_group = false

  db_cluster_parameter_group_parameters = [
    {
      name  = "client_encoding"
      value = "UTF8"
    }
  ]

  copy_tags_to_snapshot = true

  tags = {
    Name   = "${var.name}-postgresql"
    Object = "module.rds_cluster"
  }
}

resource "aws_ssm_parameter" "rds-cluster-endpoint" {
  name  = "${var.name}-rds-cluster-endpoint"
  type  = "String"
  value = module.rds_cluster.cluster_endpoint

  tags = {
    Name   = "${var.name}-rds-cluster-endpoint"
    Object = "aws_ssm_parameter.rds-cluster-endpoint"
  }
}

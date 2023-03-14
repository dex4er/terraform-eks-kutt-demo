## Master password is only one-time password that is changed by lambda then
## stored in a secrets manager

module "rds_cluster_secret" {
  source = "./modules/secret-postgresql"

  account_id = var.account_id
  region     = var.region

  secret_name = "${var.name}-postgresql"

  rotate_after_days       = 1000
  recovery_window_in_days = 0

  cluster_id              = module.rds_cluster.cluster_id
  cluster_database_name   = module.rds_cluster.cluster_database_name
  cluster_endpoint        = module.rds_cluster.cluster_endpoint
  cluster_port            = module.rds_cluster.cluster_port
  cluster_master_username = module.rds_cluster.cluster_master_username
  cluster_master_password = module.rds_cluster.cluster_master_password

  vpc_id                    = local.vpc_id
  vpc_database_subnet_cidrs = module.vpc.database_subnets_cidr_blocks
  vpc_private_subnet_ids    = module.vpc.private_subnets

  install_deployment_zip = true
}

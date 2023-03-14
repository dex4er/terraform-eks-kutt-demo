## kutt.io works with Redis 6.0

resource "aws_elasticache_subnet_group" "this" {
  name       = "${var.name}-redis"
  subnet_ids = module.vpc.elasticache_subnets
}

resource "aws_elasticache_cluster" "this" {
  cluster_id           = "${var.name}-redis"
  engine               = "redis"
  node_type            = "cache.t3.micro"
  num_cache_nodes      = 1
  parameter_group_name = "default.redis6.x"
  engine_version       = "6.0"
  port                 = 6379
  availability_zone    = var.azs[0]
  subnet_group_name    = aws_elasticache_subnet_group.this.name
}
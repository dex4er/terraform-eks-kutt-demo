## Random string for kutt.io to avoid to use hardcoded secrets

module "kutt_jwt_secret" {
  source = "./modules/secret-random-value/"

  region = var.region

  name = "${var.name}-kutt-jwt"

  password_length = 64

  recovery_window_in_days = 0
}

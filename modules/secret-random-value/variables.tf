variable "aws_secretsmanager_endpoint" {
  type        = string
  default     = ""
  description = "Secrets Manager service endpoint URL."
}

variable "exclude_characters" {
  type        = string
  default     = "!\"#$%&'()*,-.:;<=>?@[\\]^_`{|}~"
  description = "A string of the characters that you don't want in the password; default: all punctuation characters except `+` and `/`."
}

variable "install_deployment_zip" {
  type        = bool
  default     = true
  description = "Controls whether existing deployment.zip package for Lambda should be used instead packing source files."
}

variable "name" {
  type        = string
  description = "Name of the secret"
}

variable "password_length" {
  type        = number
  default     = 32
  description = "The length of the password; default: 32 characters."
}

variable "recovery_window_in_days" {
  type        = number
  default     = 0
  description = "Number of days that AWS Secrets Manager waits before it can delete the secret. This value can be 0 to force deletion without recovery or range from 7 to 30 days. Default: 7"
}

variable "region" {
  type        = string
  description = "AWS region for main resources."
}

variable "rotate_after_days" {
  type        = number
  default     = 0
  description = "Rotate password after number of days. Zero disables rotation immediately."
}

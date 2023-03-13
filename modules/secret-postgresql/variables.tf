variable "account_id" {
  type        = number
  description = "AWS Account ID for main resources."
}

variable "cluster_database_name" {
  type        = string
  description = "Name for an automatically created database on cluster creation."
}

variable "cluster_endpoint" {
  type        = string
  description = "Writer endpoint for the cluster."
}

variable "cluster_id" {
  type        = string
  description = "The RDS Cluster Identifier."
}

variable "cluster_port" {
  type        = string
  description = "The database port."
}

variable "cluster_master_password" {
  type        = string
  description = "The database master password."
}

variable "cluster_master_username" {
  type        = string
  description = "The database master username."
}

variable "install_deployment_zip" {
  type        = bool
  default     = true
  description = "Controls whether existing deployment.zip package for Lambda should be used instead packing source files."
}

variable "recovery_window_in_days" {
  type        = number
  default     = 7
  description = "Number of days that AWS Secrets Manager waits before it can delete the secret. This value can be 0 to force deletion without recovery or range from 7 to 30 days. Default: 7"
}

variable "region" {
  type        = string
  description = "AWS region for main resources."
}

variable "rotate_after_days" {
  type        = number
  default     = 1000
  description = "Rotate password after number of days. Zero disables rotation immediately."
}

variable "secret_name" {
  type        = string
  description = "Name prefix of the resources for this project."
}

variable "vpc_database_subnet_cidrs" {
  type        = list(string)
  description = "List of subnet CIDRs where database is in the VPC."
}

variable "vpc_id" {
  type        = string
  description = "ID of the VPC."
}

variable "vpc_private_subnet_ids" {
  type        = list(string)
  description = "List of subnet ids when Lambda Function should run in the VPC."
}

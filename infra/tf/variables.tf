variable "env" {
  description = "Environment"
  type        = string
  default     = "dev"
}

variable "region" {
  description = "AWS region"
  type        = string
  default     = "eu-west-1"
}


# Rds
variable "db_username" {
  description = "Username for the RDS PostgreSQL"
  type        = string
  sensitive   = true
}

variable "db_password" {
  description = "Password for the RDS PostgreSQL"
  type        = string
  sensitive   = true
}

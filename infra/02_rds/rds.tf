locals {
    env = "dev"
    region = "eu-west-1"
    db_name       = "databasetest"
    instance_name = "db-1"
}

module "db1" {
  source  = "terraform-aws-modules/rds/aws"
  version = "6.12.0"

  # Basic settings
  identifier     = local.instance_name
  engine         = "postgres"
  family         = "postgres14" # DB parameter group
  engine_version = "14"
  instance_class = "db.t4g.micro"

#   # IAM Role associations to write queries to S3
#   db_instance_role_associations = [aws_iam_role.rds_s3_export.arn]

  # Storage configuration
  allocated_storage     = 20
  max_allocated_storage = 100
  storage_encrypted     = true

  # Database credentials (Using sensitive variables)
  db_name  = local.db_name
  username = var.db_username
  password = var.db_password
  port     = 5432

  # Network settings - placement in private subnets
  multi_az               = false
  db_subnet_group_name   = data.aws_db_subnet_group.selected.name
  vpc_security_group_ids = [module.security_group.security_group_id]

  # Backup/Maintenance config
  backup_retention_period = 14
  backup_window           = "22:00-23:59"
  maintenance_window      = "Mon:02:00-Mon:05:00"
  copy_tags_to_snapshot   = true

  # Only for Dev/test
  skip_final_snapshot     = true
  deletion_protection     = false
  # ################

  tags = {
    Environment = local.env
    Terraform   = "true"
  }
}

module "security_group" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "5.3.0"

  name        = "${local.instance_name}-db-sg1"
  description = "Allow connection from private subnets vpc"
  vpc_id      = data.aws_vpc.selected.id

  # Allow access from VPC's private subnets
  ingress_with_cidr_blocks = [
    {
      from_port   = 5432
      to_port     = 5432
      protocol    = "tcp"
      description = "PostgreSQL access from private subnets"
      # cidr_blocks = join(",", module.vpc.private_subnets_cidr_blocks)
      cidr_blocks = "10.0.0.0/16"
    },
  ]

  tags = {
    Environment = local.env
    Terraform   = "true"
  }
}

locals {
    env           = "dev"
    region        = "eu-west-1"
    bucket_name   = "davide-test-query-results"
}

module "s3_bucket" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "4.8.0"

  bucket = "${local.bucket_name}"

  # Security settings
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true

  # Enable versioning
  versioning = {
    enabled = true
  }

  # Server-side encryption with AES256
  server_side_encryption_configuration = {
    rule = {
      apply_server_side_encryption_by_default = {
        sse_algorithm = "AES256"
      }
      bucket_key_enabled = true
    }
  }

  tags = {
    Environment = local.env
    Terraform   = "true"
  }

}

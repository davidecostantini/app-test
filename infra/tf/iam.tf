# Eks
data "aws_iam_policy_document" "eks_admin_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
    }
  }
}

resource "aws_iam_role" "eks_admin" {
  name               = "eks-admin-role"
  assume_role_policy = data.aws_iam_policy_document.eks_admin_assume_role.json
}

# RDS
resource "aws_iam_role" "rds_s3_export" {
  name = "${local.bucket_name}-rds-s3-export"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = { Service = "rds.amazonaws.com" }
      Action    = "sts:AssumeRole"
    }]
  })
}

# Attach policy to allow S3 access
resource "aws_iam_role_policy" "rds_s3_access" {
  name   = "s3-access"
  role   = aws_iam_role.rds_s3_export.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect   = "Allow"
      Action   = ["s3:PutObject", "s3:GetObject", "s3:ListBucket"]
      Resource = [
        module.s3_bucket.s3_bucket_arn,
        "${module.s3_bucket.s3_bucket_arn}/*"
      ]
    }]
  })
}

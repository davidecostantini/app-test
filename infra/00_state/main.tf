locals {
    env = "dev"
    region = "eu-west-1"
}

resource "aws_s3_bucket" "tf_state_s3_bucket" {
  bucket = "${var.s3_state_bucket}"

  lifecycle {
    prevent_destroy = false
  }

  tags = {
    Name      = "Terraform State files for ${local.env}"
    ManagedBy = "terraform"
    env       = "${local.env}"
  }
}

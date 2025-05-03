data "aws_vpc" "selected" {
  filter {
    name   = "tag:Name"
    values = ["vpc-${local.env}"]
  }
}

data "aws_db_subnet_group" "selected" {
  name = "vpc-${local.env}"
}
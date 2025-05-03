data "aws_vpc" "selected" {
  filter {
    name   = "tag:Name"
    values = ["vpc-${local.env}"]
  }
}

data "aws_subnets" "all" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.selected.id]
  }
}

locals {
  private_subnets = [
    for subnet in data.aws_subnets.all.ids : subnet
    if startswith(
      lookup(
        data.aws_subnet.by_id[subnet].tags,
        "Name",
        ""
      ),
      "vpc-dev-private"
    )
  ]

  intra_subnets = [
    for subnet in data.aws_subnets.all.ids : subnet
    if startswith(
      lookup(
        data.aws_subnet.by_id[subnet].tags,
        "Name",
        ""
      ),
      "vpc-dev-intra"
    )
  ]
}

# This reads full data for each subnet ID
data "aws_subnet" "by_id" {
  for_each = toset(data.aws_subnets.all.ids)
  id       = each.value
}


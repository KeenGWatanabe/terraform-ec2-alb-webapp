data "aws_vpc" "selected" {
  filter {
    name   = "tag:Name"
    values = ["roger_vpc"]
  }
}

data "aws_subnets" "public" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.selected.id]
  }
  filter {
    name   = "tag:Name"
    values = ["*public*"]
  }
}
# Add a data resource to get details of a single subnet from the list
data "aws_subnet" "public" {
  id = data.aws_subnets.public.ids[0]  # Assuming you want the first subnet in the list
}
data "aws_subnets" "private" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.selected.id]
  }
  filter {
    name   = "tag:Name"
    values = ["*private*"]
  }
}

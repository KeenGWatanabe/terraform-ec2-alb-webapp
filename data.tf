data "aws_subnets" "public" {
  filter {
    name   = "vpc-id"
    values = [module.aws_vpc.vpc_id]
  }
  filter {
    name   = "tag:Name"
    values = ["public_subnet"]
  }
}

data "aws_subnet" "public" {
  id = data.aws_subnets.public.ids[0]  # Assuming you want the first subnet in the list
}

data "aws_subnets" "private" {
  filter {
    name   = "vpc-id"
    values = [module.aws_vpc.vpc_id]
  }
  filter {
    name   = "tag:Name"
    values = ["*private*"]
  }
}

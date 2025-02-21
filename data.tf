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

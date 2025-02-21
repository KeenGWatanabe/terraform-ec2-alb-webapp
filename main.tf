locals {
  name_prefix = "rger" # provide your name prefix
}
module "aws_vpc" {
  #https method
  source             = "git::https://github.com/KeenGWatanabe/terraform-vpc"
  aws_region         = "us-east-1"
  vpc_cidr_block     = "10.0.0.0/16"
  public_subnet_cidr = ["10.0.1.0/24", 
"10.0.2.0/24",
"10.0.3.0/24",
"10.0.4.0/24" ]
}
# outputs.tf in the module
output "vpc_id" {
  value = module.aws_vpc.vpc.id
}

output "public_subnet_ids" {
  value = module.aws_vpc.public_subnet_ids
}

module "web_app" {
  source            = "./modules/web_app"
  name_prefix       = local.name_prefix
  instance_type     = "t2.micro"
  vpc_id            = module.aws_vpc.vpc_id
  public_subnet_ids = module.aws_vpc.public_subnet_ids
}

module "alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "9.12.0"
  name    = "${local.name_prefix}-webapp-alb"
  vpc_id  = module.aws_vpc.vpc_id
  subnets = module.aws_vpc.public_subnet_ids
  enable_deletion_protection = false

  # Security Group
  security_group_ingress_rules = {
    all_http = {
      from_port   = 80
      to_port     = 80
      ip_protocol = "tcp"
      description = "HTTP web traffic"
      cidr_ipv4   = "0.0.0.0/0"
    }
    all_https = {
      from_port   = 443
      to_port     = 443
      ip_protocol = "tcp"
      description = "HTTPS web traffic"
      cidr_ipv4   = "0.0.0.0/0"
    }
  }
  security_group_egress_rules = {
    all = {
      ip_protocol = "-1"
      cidr_ipv4   = "0.0.0.0/0"
    }
  }
}

resource "aws_lb_listener" "web_app" {
  load_balancer_arn = module.alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = module.web_app.target_group_arn
  }
}

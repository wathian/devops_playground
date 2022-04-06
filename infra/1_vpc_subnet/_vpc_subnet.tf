module "vpc" {
  # source = "cloudposse/vpc/aws"
  source = "../modules/terraform-aws-vpc"
  # Cloud Posse recommends pinning every module to a specific version
  # version     = "x.x.x"
  namespace  = "symbiosis"
  stage      = "dev"
  name       = "vpc"
  cidr_block = "192.168.0.0/16"
  ipv6_enabled = false
  internet_gateway_enabled = true
  default_security_group_deny_all = false
}

# This will create equal amount of private & public subnet base on max_subnet_count & availability_zones
# if max_subnet_count = 2, availability_zones = 2 -> 2/2*2 private and 2/2*2 public
# if max_subnet_count = 4, availability_zones = 3 -> 4/2*3 private and 4/2*3 public
module "subnet" {
  source = "../modules/terraform-aws-dynamic-subnets"
  # Cloud Posse recommends pinning every module to a specific version
  # version     = "x.x.x"
  namespace          = "symbiosis"
  stage              = "dev"
  name               = "subnet"
  availability_zones = ["ap-southeast-1a","ap-southeast-1b"]
  vpc_id             = module.vpc.vpc_id
  igw_id             = module.vpc.igw_id
  # cidr_block         = "192.168.0.0/16"
  cidr_block         = module.vpc.vpc_cidr_block
  max_subnet_count   = 2
  nat_gateway_enabled = false
}
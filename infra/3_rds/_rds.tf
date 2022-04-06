# module "security_group" {
#   source  = "../modules/terraform-aws-security-group"

# #   use_name_prefix = var.security_group_use_name_prefix
#   rules           =  [
#     {
#       type        = "egress"
#       from_port   = 0
#       to_port     = 65535
#       protocol    = "-1"
#       cidr_blocks = ["0.0.0.0/0"]
#     },
#     {
#       type        = "ingress"
#       from_port   = 22
#       to_port     = 22
#       protocol    = "tcp"
#     #   cidr_blocks = ["0.0.0.0/0"]
#       cidr_blocks = ["220.255.65.0/24"]
#     },
#     {
#       type        = "ingress"
#       from_port   = 3306
#       to_port     = 3306
#       protocol    = "tcp"
#       cidr_blocks = ["192.168.128.0/18", "192.168.192.0/18"]
#     },
#     {
#       type        = "ingress"
#       from_port   = 443
#       to_port     = 443
#       protocol    = "tcp"
#       cidr_blocks = ["0.0.0.0/0"]
#     },
#     # {
#     #   type        = "ingress"
#     #   from_port   = 53
#     #   to_port     = 53
#     #   protocol    = "udp"
#     #   cidr_blocks = ["0.0.0.0/0"]
#     # },
#   ]
#   description     = "Security Group for MySQL RDS"
#   vpc_id          = "vpc-046b1ecd264f43af1"
# }

module "rds_instance" {
  source             = "../modules/terraform-aws-rds"
  namespace          = "symbiosis"
  stage              = "dev"
  name               = "rds"
  database_name      = "app"
  database_user      = "root"
  database_password  = "rootingforu"
  database_port      = 3306
  multi_az           = false
  storage_type       = "gp2"
  allocated_storage  = 8
  storage_encrypted  = false
  engine             = "mysql"
  engine_version     = "8.0.28"
  instance_class     = "db.t2.micro"
  publicly_accessible = false
  allowed_cidr_blocks = ["192.168.128.0/18", "192.168.192.0/18"]
  vpc_id              = "vpc-046b1ecd264f43af1"
  subnet_ids          = ["subnet-06de3e8c791bf3b9e", "subnet-0e858b497277305fa"]
  # security_group_ids  = [module.security_group.id]
  apply_immediately   = true
  auto_minor_version_upgrade = false
  # option_group_name = "symbiosis-dev-rds-og"
  # parameter_group_name = "symbiosis-dev-rds-pg"
  db_parameter_group = "mysql8.0"
}
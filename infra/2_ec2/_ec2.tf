module "aws_key_pair" {
  source              = "../modules/terraform-aws-key-pair"
  namespace           = "symbiosis"
  stage               = "dev"
  name                = "ec2"
  ssh_public_key_path = "~/.ssh"
  ssh_public_key_file = "symbiosis.ec2.rsa2.pem.pub"
  generate_ssh_key    = false
}

module "nodejs" {
  source = "../modules/terraform-aws-ec2-instance"
  # Cloud Posse recommends pinning every module to a specific version
  # version     = "x.x.x"
  ami = "ami-0801a1e12f4a9ccc0"
  ami_owner = "137112412989"
  ssh_key_pair = module.aws_key_pair.key_name
  instance_type = "t2.micro"
  vpc_id = "vpc-046b1ecd264f43af1"
  subnet = "subnet-046b92952ce519f52"
  security_groups = []
  name                        = "ec2"
  namespace                   = "symbiosis"
  stage                       = "dev"
  assign_eip_address = false
  associate_public_ip_address = true
  monitoring = false
  root_volume_size = 8
#   ebs_volume_encrypted = false
  security_group_rules = [
    {
      type        = "egress"
      from_port   = 0
      to_port     = 65535
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      type        = "ingress"
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
    #   cidr_blocks = ["0.0.0.0/0"]
      cidr_blocks = ["220.255.65.0/24"]
    },
    # {
    #   type        = "ingress"
    #   from_port   = 80
    #   to_port     = 80
    #   protocol    = "tcp"
    #   cidr_blocks = ["0.0.0.0/0"]
    # },
    # {
    #   type        = "ingress"
    #   from_port   = 443
    #   to_port     = 443
    #   protocol    = "tcp"
    #   cidr_blocks = ["0.0.0.0/0"]
    # },
    {
      type        = "ingress"
      from_port   = 3000
      to_port     = 3000
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
  ]
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

locals {
  common_tags = { "project" = "tf-demo-esau" }
}

module "vpc" {
  source = "./modules/vpc"
  providers = {
    aws.east = aws.east
    aws.west = aws.west
  }
  cidr_block        = "10.1.0.0/26"
  subnet_cidr_block = "10.1.0.0/28"
  private_ips       = ["10.1.0.12"]
  tags              = local.common_tags
}

module "instance" {
  source               = "./modules/instance"
  ami                  = data.aws_ami.ubuntu.id
  instance_type        = "t3.micro"
  network_interface_id = module.vpc.network_interface_id
  device_index         = 0
  tags                 = local.common_tags
}

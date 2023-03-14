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
  common_tags = { "project" = "${terraform.workspace}-tf-demo-esau" }
}
module "vpc" {
  source = "./modules/vpc"
  providers = {
    aws.east = aws.east
    aws.west = aws.west
  }
  cidr_block        = terraform.workspace == "dev" ? "10.1.0.0/26" : terraform.workspace == "stg" ? "10.2.0.0/26" : "null"
  subnet_cidr_block = terraform.workspace == "dev" ? "10.1.0.0/28" : terraform.workspace == "stg" ? "10.2.0.0/28" : "null"
  #private_ips       = tolist([local.ips[count.index]])
  num_interfaces = length(var.instances)
  tags           = local.common_tags
}

module "instance" {
  count                = length(var.instances)
  source               = "./modules/instance"
  ami                  = data.aws_ami.ubuntu.id
  instance_type        = var.instances[count.index].type
  network_interface_id = module.vpc.network_interface_id[count.index]

  name = "${terraform.workspace}-${var.instances[count.index].name}"
  tags = local.common_tags
}
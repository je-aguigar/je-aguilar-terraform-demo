terraform {
  required_providers {
    aws = {
      source                = "hashicorp/aws"
      version               = "~> 4.0"
      configuration_aliases = [aws.east, aws.west]
    }
  }
}

resource "aws_vpc" "vpc" {
  provider   = aws.east
  cidr_block = var.cidr_block #"10.1.0.0/26"
  tags       = var.tags
}

resource "aws_subnet" "subnet" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = var.subnet_cidr_block #"10.1.0.0/28"
  tags       = var.tags
}

resource "aws_network_interface" "interface" {
  subnet_id   = aws_subnet.subnet.id
  private_ips = var.private_ips #["10.1.0.12"]
  tags        = var.tags
}

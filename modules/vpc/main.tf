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
  count     = var.num_interfaces
  subnet_id = aws_subnet.subnet.id
  tags = merge(
    { name = "interface-${count.index + 1}" },
    var.tags
  )
}

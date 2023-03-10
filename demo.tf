terraform {
  backend "local" {
    path = "./terraform.tfstate"
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
    docker = {
      source  = "kreuzwerker/docker"
      version = "3.0.1"
    }
  }
}

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

provider "aws" {
  alias  = "east"
  region = "us-east-1"
}

provider "aws" {
  alias  = "west"
  region = "us-west-1"
}

resource "aws_vpc" "esau-vpc" {
  provider   = aws.east
  cidr_block = "10.1.0.0/26"
  tags = {
    Name = "esau-vpc"
  }
}

resource "aws_subnet" "subnet1" {
  vpc_id     = aws_vpc.esau-vpc.id
  cidr_block = "10.1.0.0/28"
  tags = {
    Name = "subnet1"
  }
}

resource "aws_network_interface" "interface1" {
  subnet_id   = aws_subnet.subnet1.id
  private_ips = ["10.1.0.12"]
  tags = {
    Name = "primary_network_interface"
  }
}

resource "aws_network_interface" "interface2" {
  subnet_id   = aws_subnet.subnet1.id
  private_ips = ["10.1.0.10"]
  tags = {
    Name = "primary_network_interface"
  }
}
resource "aws_instance" "instance1" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.micro"
  network_interface {
    network_interface_id = aws_network_interface.interface2.id
    device_index         = 0
  }
  tags = {
    Name = "instance1"
  }
}

resource "aws_instance" "instance2" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.micro"
  network_interface {
    network_interface_id = aws_network_interface.interface2.id
    device_index         = 0
  }
  tags = {
    Name = "instance2"
  }
}
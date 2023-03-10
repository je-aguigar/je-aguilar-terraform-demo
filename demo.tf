terraform {
  backend "local" {
    path = "/Users/esauaguilar/Desktop/terraform/terraform.tfstate"
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

provider "aws" {
  alias = "east"
  region = "us-east-1"
}

provider "aws" {
  alias = "west"
  region = "us-west-1"
}
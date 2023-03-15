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
/*
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
}*/

resource "docker_image" "nginx" {
  name         = "nginx:1.23"
  keep_locally = false
}

resource "docker_container" "nginx" { # Tainted
  image = docker_image.nginx.image_id
  name  = "test"
  ports {
    internal = 80
    external = 8000
  }
}

resource "docker_container" "imported" {
  attach = false
  command = [
    "nginx",
    "-g",
    "daemon off;",
  ]
  container_read_refresh_timeout_milliseconds = 15000
  cpu_shares                                  = 0
  dns                                         = []
  dns_opts                                    = []
  dns_search                                  = []
  entrypoint = [
    "/docker-entrypoint.sh",
  ]
  env               = []
  group_add         = []
  hostname          = "5ee198ae764a"
  image             = "sha256:904b8cb13b932e23230836850610fa45dce9eb0650d5618c2b1487c2a4f577b8"
  init              = false
  ipc_mode          = "private"
  log_driver        = "json-file"
  log_opts          = {}
  logs              = false
  max_retry_count   = 0
  memory            = 0
  memory_swap       = 0
  must_run          = true
  name              = "importMe"
  network_mode      = "default"
  privileged        = false
  publish_all_ports = false
  read_only         = false
  remove_volumes    = true
  restart           = "no"
  rm                = false
  runtime           = "runc"
  security_opts     = []
  shm_size          = 64
  start             = true
  stdin_open        = false
  stop_signal       = "SIGQUIT"
  stop_timeout      = 0
  storage_opts      = {}
  sysctls           = {}
  tmpfs             = {}
  tty               = false
  wait              = false
  wait_timeout      = 60

  ports {
    external = 8080
    internal = 80
    ip       = "0.0.0.0"
    protocol = "tcp"
  }
}



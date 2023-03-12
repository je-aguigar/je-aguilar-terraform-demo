variable "ami" {}

variable "instance_type" {
  default = "t2.micro"
}

variable "network_interface_id" {}

variable "device_index" {
  default = 0
}

variable "tags" {}

resource "aws_instance" "instance" {
  ami           = var.ami           #data.aws_ami.ubuntu.id
  instance_type = var.instance_type #"t3.micro"
  network_interface {
    network_interface_id = var.network_interface_id
    device_index         = var.device_index
  }
  tags = var.tags
}

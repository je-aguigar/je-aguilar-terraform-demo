resource "aws_instance" "instance" {
  ami           = var.ami #data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  network_interface {
    network_interface_id = var.network_interface_id
    device_index         = 0
  }
  tags = merge(
    { Name = var.name },
    var.tags
  )
  /*
  validation {
      condition = can(regex("^(?=.{4,30}$)(?!.*__.*)(?!.*_$)[a-z]{3,8}+[_]{1}[_a-z0-9]*[a-z0-9]$", var.name))

      error_message = "el nombre no es correcto"
  }*/
}

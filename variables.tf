
/*variable "instances" {
  type = list(object({
    name = string
    type = string
  }))

  validation {
    condition = alltrue([
      for v in var.instances : contains(["t2.micro", "t3.micro"], v.type)
    ])

    error_message = "No puedes usar este tipo de instancia para POC tests"
  }
}

*/
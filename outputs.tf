/*output "interfaces" {
  value = module.vpc.network_interface_id
}

output "wspaces" {
  value = terraform.workspace
}
*/

output "key" {
  value = tls_private_key.oskey.public_key_openssh
}

output "public_ip" {
  value = aws_instance.web.public_ip
}

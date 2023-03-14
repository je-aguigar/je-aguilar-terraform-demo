output "interfaces" {
  value = module.vpc.network_interface_id
}

output "wspaces" {
  value = terraform.workspace
}

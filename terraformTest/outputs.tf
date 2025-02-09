output "dns_output"{
  value = module.alb.meitar_alb_dns_name
}
output "vpc_output" {
  value = module.network
}

output "ec2_output" {
  value = module.ec2
}
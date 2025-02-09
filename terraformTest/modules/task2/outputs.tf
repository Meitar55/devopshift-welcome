output "security_group_id" {
  value = aws_security_group.sg.id
}
output "instance_publicIP"{
  description = "vm public ip"
  value = [for vm in aws_instance.meitar-vm : vm.public_ip]
}
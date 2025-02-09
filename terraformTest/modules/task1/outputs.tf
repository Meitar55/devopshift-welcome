output "vpc_id" {
  value = aws_vpc.vpc_meitar.id
}

output "public_subnet_id" {
  description = "the ids of the public subnet"
  value = [for subnet in aws_subnet.public_subnet : subnet.id]//could be plural, according to user input from root
}
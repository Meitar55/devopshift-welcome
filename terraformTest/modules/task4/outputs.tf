output "meitar_alb_dns_name" {
  description = "The dns name of the ALB"
  value = aws_lb.meitar-alb.dns_name
}
module "create_ec2" {
  source = "./Modules"
  ami = "ami-0c02fb55956c7d316"
  machine_type = "t2.micro"
}

output "print_module_ami" {
  value = module.create_ec2.print_ami
}
output "print_module_publicIP" {
  value = module.create_ec2.vm_public_ip
}
output "print_module_region" {
  value = module.create_ec2.print_region
}


variable enabled_services{
    default = []
}

variable "s3_buckets" {
  type    = set(string)
  default = ["prod", "dev"]
}

resource "aws_s3_bucket" "buckets" {
  for_each = var.enabled_services

  bucket = "my-app-${each.key}"
  acl    = "private"

  tags = {
    Name        = "Bucket for ${each.key}"
    Environment = "${each.key}"
  }
}


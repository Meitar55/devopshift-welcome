provider "aws" {
  region = var.region
}

variable "region" {
  default = "us-east-1"
}

data "aws_instance" "yaniv_vmIP" {
  instance_id = "i-09df7e0ed385f871b"
}

output "vm_public_ip" {
   description = "The public IP address of the Yaniv VM instance"
   value = data.aws_instance.yaniv_vmIP.public_ip
} 
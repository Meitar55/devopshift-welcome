provider "aws" {
 region = var.region
}

variable "region" {
 default = "us-east-1"
}

variable "vm_name" {
 default = "vm-Meitar"
}

variable "admin_username" {
 default = "admin-user"
}

variable "admin_password" {
 default = "Password123!"
}

variable "vm_size" {
 default = "t2.micro"
}

data "aws_ami" "my-privateami" {
    owners = ["self"]  # Queries only AMIs owned by your account

}

data "aws_ami" "vm_ami"{
 owners = ["self"]
 filter {
   name = "name"
   values= ["terraform-workshop-image-do-not-delete"]
 }
}



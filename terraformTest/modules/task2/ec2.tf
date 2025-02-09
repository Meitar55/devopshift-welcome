variable "ami_id" {
  default = "ami-0e1bed4f06a3b463d" #Ubuntu 22.04
}
variable "instance_type" {
  type=string
  default = "t2.micro"
}
variable "subnet_id" {
    type=list(string)//it could be multiple
    default = []
}
variable "vpc"{
  default = ""
}
variable "assignPublicIP"{
  default=true
}

resource "aws_security_group" "sg" {
vpc_id = var.vpc
 ingress {
   from_port   = 22
   to_port     = 22
   protocol    = "tcp"
   cidr_blocks = ["0.0.0.0/0"]
 }

    ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
 egress {
   from_port   = 0
   to_port     = 0
   protocol    = "-1"
   cidr_blocks = ["0.0.0.0/0"]
 }
}

resource "aws_instance" "meitar-vm" {
  count = length(var.subnet_id)
  ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = var.subnet_id[count.index]
  vpc_security_group_ids      = [aws_security_group.sg.id]
  associate_public_ip_address = var.assignPublicIP

  tags = {
    Name = "meitar-vm${count.index}"
  }
}



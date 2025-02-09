provider "aws" {
  region = "us-east-1" 
}

module "network" {
  source = "./modules/task1" 
  cidrBlockRange = 16
  countPublicSubnets=2
  countPrivateSubnets=1
}

module "ec2" {
  source = "./modules/task2"
  subnet_id = module.network.public_subnet_id
  vpc = module.network.vpc_id
  instance_type="t2.micro"
  assignPublicIP=true
}
module "alb" {
  source         = "./modules/task4"
  vpc         = module.network.vpc_id
  subnet_id = module.network.public_subnet_id
  instance_type  = "t2.micro"
  min_size       = 1
  max_size       = 3
}

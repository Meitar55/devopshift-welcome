provider "aws" {
  region = "us-east-1" 
}

module "network" {
  source = "./modules/task1" 
  cidrBlockRange = 16
  countPublicSubnets=1
  countPrivateSubnets=1
}

module "ec2" {
  source = "./modules/task2"
  subnet_id = module.network.public_subnet_id
  vpc = module.network.vpc_id
  instance_type="t2.micro"
}
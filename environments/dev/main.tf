
provider "aws" {
  region = "us-east-1"
}
module "vpc" {
  source = "../../module/vpc"
}

module "ec2" {
  source        = "../../module/ec2" #this is the path to ec2 which will be changed in every enviroment
  instance_type = var.instance_type
  subnet_id     = module.vpc.subnet_id
  vpc_id        = module.vpc.vpc_id
}

module "s3" {
  source = "../../module/s3"
}
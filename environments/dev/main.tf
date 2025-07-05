
provider "aws" { # first thing is to mention provider, which is aws in 
                 #this case
  region = "us-east-1" /*
  Region: us-east-1 (can be changed as needed).
  Make sure all resources are deployed in the same region to avoid cross-region issues.

  Objective:
  We are creating three resources — EC2, VPC, and S3 — each defined as a separate Terraform resource.

  Module Structure:
  - Each resource is placed in its own module: `ec2`, `vpc`, and `s3`.
  - Using modules allows us to reuse code efficiently across multiple environments (dev, test, prod).
  - This modular approach improves code readability, maintainability, and reduces duplication.
*/
}
module "ec2"{ #  under aws provider mentioning module ec2(aws instance),a ref name only
  source        = "../../module/ec2" #this is the path to ec2 which will be 
  # changed in every enviroment
  instance_type = var.instance_type # launching ec2 always require instance type
  # we need variable instance type as per different enviroment 
  subnet_id     = module.vpc.subnet_id # subnet will be created as per our 
  # user defined name under 
  vpc_id        = module.vpc.vpc_id # module vpc will clear which vpc name 
  #we will assign with user defines cidr
}
module "vpc" {# VPC module declaration
  source = "../../module/vpc"  # path to the vpc module
}
module "s3" { # s3 module declaration 
  source = "../../module/s3" # path to the s3 module
}# opening and closing  bracket needs in every module ,resources,variales etc
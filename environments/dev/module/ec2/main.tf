resource "aws_instance" "kuch_bi" { #under ec2-main.tf ,we decare 
  #aws_instance  kuch_bi is the name of the resource, it can be 
  #anything .
  ami           = "ami-05ffe3c48a9991133"  # Replace with a real AMI ID
  instance_type = var.instance_type # still variable based instance 
  #because of different enviroment,we will specify actual instance type on 
  #enviroments only
  
    subnet_id     = var.subnet_id # define in vpc module

    tags = {
    Name = "kuch-bi-${terraform.workspace}"# Naming the resource 
    #dynamically using the current Terraform workspace.
  }
}

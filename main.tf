provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "my_ec2" {
  ami           = "ami-09e6f87a47903347c"  # Amazon Linux 2 for us-east-1
  instance_type = "t2.micro"
  subnet_id     = "subnet-0fd018b91534da3f9"

  tags = {
    Name = "MyFirstEC2"
  }
}
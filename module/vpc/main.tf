resource "aws_vpc" "ref_name_only" { # ref_name_only 
  cidr_block = "10.0.0.0/16" # user defined block
  tags = {
    Name = "MyVPC" #name of vpc
  }
}

resource "aws_subnet" "my_subnet" {# defining subnet ref
  vpc_id            = aws_vpc.ref_name_only.id # MyVPC will 
  # be taken in auto mode from previous code
  cidr_block        = "10.0.1.0/24" # user define lower ip range
  availability_zone = "us-east-1a" # AZ's

  tags = {
    Name = "MySubnet"# name of the subnet
  }
}

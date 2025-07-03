resource "aws_vpc" "ref_name_only" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "MyVPC"
  }
}

resource "aws_subnet" "my_subnet" {
  vpc_id            = aws_vpc.ref_name_only.id  # ✅ Correct: use the actual resource name + `.id`
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "MySubnet"
  }
}

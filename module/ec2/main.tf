resource "aws_instance" "kuch_bi" {
  ami           = "ami-05ffe3c48a9991133"  # Replace with a real AMI ID
  instance_type = var.instance_type
  
    subnet_id     = var.subnet_id

    tags = {
    Name = "kuch-bi-${terraform.workspace}"
  }
}

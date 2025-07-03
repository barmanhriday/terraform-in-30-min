output "subnet_id" {
  value = aws_subnet.my_subnet.id
}

output "vpc_id" {
  value = aws_vpc.ref_name_only.id
}

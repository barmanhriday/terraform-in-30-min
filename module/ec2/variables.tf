variable "instance_type" {
  description = "EC2 instance type"
  type        = string
}
variable "subnet_id" {
  description = "Subnet ID to launch the EC2 in"
  type        = string
}
variable "vpc_id" {
  type = string
}
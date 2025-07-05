variable "instance_type" {
  description = "EC2 instance type"
  type        = string # variables will be called
  # in enviroment only as per enviroments
}
variable "subnet_id" {
  description = "Subnet ID to launch the EC2 in"
  type        = string# variables will be called
  # in vpc module only
}
variable "vpc_id" {
  type = string# variables will be called
  # in vpc module  only
}
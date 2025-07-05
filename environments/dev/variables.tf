variable "instance_type" { # this value will be defined in
#.tfvar file with actual value as per enviroment
# subnet and vpc already known and hence  no need to mention  
# again
  description = "EC2 instance type"
  type        = string # any character 
}


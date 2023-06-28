variable "subnet_id" {
    description = "Subnet ID"
}

variable "environment" {
  description = "Deployment Environment"
}

variable "vpc_id" {
}

variable "allow_src_cidr" {
  
}

variable "key_name" {
  default = "asg-key"
}

variable "security_group_id" {
 
}
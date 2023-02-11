variable "vpc_id" {
  description = "my default VPC id"
  default     = "vpc-05825a2e3056eb26c"
}

variable "ssh_access_cidr_blocks" {
    description = "cidr list for ssh access to ec2"
    default = ["76.169.181.157/32","79.110.137.97/32"]
}

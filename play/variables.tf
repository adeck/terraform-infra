
variable "access_key" {}
variable "secret_key" {}
variable "geo" {
  default = "us-west-1"
}

variable "instance_ami" {
  default = "ami-7a85a01a"
}

variable "vpc_cidr" {}
variable "vpc_name" {}

variable "domain" {}

variable "trusted_cidr" {}


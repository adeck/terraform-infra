
### inputs

variable "vpc_id" {}
variable "vpc_name" {}

variable "ami_id" {}

# security
variable "key_name" {}
variable "default_sg_id" {}
variable "trusted_cidr" {}
# networking
variable "subnet_id" {}
# dns
variable "public_zone_id" {}
variable "private_zone_id" {}
variable "private_domain_name" {}



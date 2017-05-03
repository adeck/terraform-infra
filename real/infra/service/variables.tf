
variable "name" {}
variable "service_dns" {}

variable "instance_ami" {}

variable "vpc_name" {}
variable "key_name" {}
variable "security_group_ids" {type = "list"}
variable "subnet_id" {}
variable "public_zone_id" {}
variable "private_zone_id" {}





### inputs

variable "name" {}

variable "instance_ami" {}

variable "vpc_name" {}
variable "key_name" {}
variable "security_group_ids" {type = "list"}
variable "subnet_id" {}
variable "private_zone_id" {}
variable "private_domain_name" {}

### outputs

output "instance_id" {
    value = "${ aws_instance.main.id }"
}



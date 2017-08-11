
### inputs

variable "name" {}
variable "instance_ami" {}

# security
variable "key_name" {}
variable "security_group_ids" {type = "list"}
# networking
variable "subnet_id" {}
# dns
variable "private_zone_id" {}
variable "private_domain_name" {}

### outputs

output "instance_id" {
    value = "${ aws_instance.main.id }"
}



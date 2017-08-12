
### inputs

variable "service_name" {}
variable "ami_id" {}

# security
variable "key_name" {}
variable "security_group_ids" {type = "list"}
variable "iam_profile" {
  default = ""
}
# networking
variable "subnet_id" {}
# dns
variable "private_zone_id" {}
variable "private_domain_name" {}



### inputs

variable "name" {type = string}

variable "instance_ami" {type = string}
variable "instance_type" {
    type = string
    # even this might be more than we need
    # as of 2022-7-1 the t4g.nano is $0.0042 / hr in oregon
    # so, average of $3.066 / month
    default = "t4g.nano"
}
# value in GiB, as in aws_instance
variable "volume_size" {
    type = number
    default = 8
}
variable "vpc_name" {type = string}
variable "key_name" {type = string}
variable "security_group_ids" {type = list(string)}
variable "subnet_id" {type = string}
variable "private_zone_id" {type = string}
variable "private_domain_name" {type = string}

### outputs

output "instance_id" {
    value = aws_instance.main.id
}




output "instance_id" {
  value = "${ module.appliance_salt.instance_id }"
}

output "sg_id" {
  value = "${ aws_security_group.salt.id }"
}


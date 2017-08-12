
output "instance_id" {
    value = "${ module.appliance_gw.instance_id }"
}

output "sg_id" {
  value = "${ aws_security_group.gw.id }"
}




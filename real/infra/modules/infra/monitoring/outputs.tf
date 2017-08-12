
output "instance_id" {
  value = "${ module.appliance_monitoring.instance_id }"
}

output "sg_id" {
  value = "${ aws_security_group.monitoring.id }"
}



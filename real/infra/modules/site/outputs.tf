
#### dns

output "public_zone_id" {
  value = "${ data.aws_route53_zone.public.zone_id }"
}
output "private_zone_id" {
  value = "${ aws_route53_zone.private.id }"
}

#### ami_id

output "default_ami_id" {
  value = "${ data.aws_ami.main.id }"
}

#### networking

output "vpc_id" {
  value = "${ aws_vpc.main.id }"
}

output "dmz_subnet_id" {
  value = "${ aws_subnet.dmz.id }"
}

output "infra_subnet_id" {
  value = "${ aws_subnet.infra.id }"
}

#### security

output "default_sg_id" {
  value = "${ aws_security_group.main.id }"
}

output "key_name" {
  value = "${ aws_key_pair.main.key_name }"
}



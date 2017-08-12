
module "appliance_salt" {
    source = "appliance"
    service_name = "salt-infra"
    key_name = "${ var.key_name }"
    security_group_ids = [
        "${ var.default_sg_id }",
        "${ aws_security_group.salt.id }"
    ]
    ami_id = "${ var.ami_id }"
    subnet_id = "${ var.subnet_id }"
    private_zone_id = "${ var.private_zone_id }"
    private_domain_name = "${ var.private_domain_name }"
}


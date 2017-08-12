
module "public_gw" {
    source = "public_endpoint"
    name = "gw"
    instance_id = "${ module.appliance_gw.instance_id }"
    zone_id = "${ var.public_zone_id }"
}

module "appliance_gw" {
    source = "appliance"
    service_name = "gw-infra"
    key_name = "${ var.key_name }"
    security_group_ids = [
        "${ var.default_sg_id }",
        "${ aws_security_group.gw.id }"
    ]
    ami_id = "${ var.ami_id }"
    subnet_id = "${ var.subnet_id }"
    private_zone_id = "${ var.private_zone_id }"
    private_domain_name = "${ var.private_domain_name }"
}


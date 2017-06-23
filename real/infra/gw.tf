
module "public_gw" {
    source = "./public_endpoint"
    service_hostname = "gw"
    instance_id = "${ module.appliance_gw.instance_id }"
    zone_id = "${ data.aws_route53_zone.main.id }"
}

module "appliance_gw" {
    name = "gw"
    source = "./appliance"
    vpc_name = "${ var.vpc_name }"
    key_name = "${ aws_key_pair.main.key_name }"
    security_group_ids = [
        "${ aws_security_group.main.id }",
        "${ aws_security_group.gw.id }"
    ]
    instance_ami = "${ data.aws_ami.main.id }"
    subnet_id = "${ aws_subnet.dmz.id }"
    private_zone_id = "${ aws_route53_zone.private.id }"
    private_domain_name = "${ aws_route53_zone.private.name }"
}

resource "aws_security_group" "gw" {
  name        = "${ var.vpc_name }-gw"
  description = "Allow inbound SSH traffic from trusted networks"
  vpc_id = "${ aws_vpc.main.id }"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol = "tcp"
    cidr_blocks = ["${ var.trusted_cidr }"]
  }

  tags {
      Name = "${ var.vpc_name }-gw"
  }
}


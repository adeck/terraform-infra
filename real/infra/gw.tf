
module "gw" {
    name = "gw"
    source = "./service"
    service_dns = "midgard"

    instance_ami = "${ var.instance_ami }"
    vpc_name = "${ var.vpc_name }"
    key_name = "${ aws_key_pair.main.key_name }"
    security_group_ids = [
        "${ aws_security_group.main.id }",
        "${ aws_security_group.gw.id }"
    ]
    subnet_id = "${ aws_subnet.infra.id }"
    zone_id = "${ aws_route53_zone.infra.zone_id }"
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


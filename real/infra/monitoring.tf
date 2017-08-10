
module "appliance_monitoring" {
    name = "monitoring"
    source = "./appliance"
    vpc_name = "${ var.vpc_name }"
    key_name = "${ aws_key_pair.main.key_name }"
    security_group_ids = [
        "${ aws_security_group.main.id }",
        "${ aws_security_group.monitoring.id }"
    ]
    instance_ami = "${ data.aws_ami.main.id }"
    subnet_id = "${ aws_subnet.infra.id }"
    private_zone_id = "${ aws_route53_zone.private.id }"
    private_domain_name = "${ aws_route53_zone.private.name }"
}

resource "aws_security_group" "monitoring" {
  name        = "${ var.vpc_name }-monitoring"
  description = "monitoring master servers"
  vpc_id = "${ aws_vpc.main.id }"

  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol = "tcp"
    security_groups = ["${ aws_security_group.gw.id }"]
  }

  tags {
      Name = "${ var.vpc_name }-monitoring"
  }
}


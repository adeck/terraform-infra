
module "appliance_nagios" {
    name = "nagios"
    source = "./appliance"
    vpc_name = "${ var.vpc_name }"
    key_name = "${ aws_key_pair.main.key_name }"
    security_group_ids = [
        "${ aws_security_group.main.id }",
        "${ aws_security_group.nagios.id }"
    ]
    instance_ami = "${ data.aws_ami.main.id }"
    subnet_id = "${ aws_subnet.infra.id }"
    private_zone_id = "${ aws_route53_zone.private.id }"
    private_domain_name = "${ aws_route53_zone.private.name }"
}

resource "aws_security_group" "nagios" {
  name        = "${ var.vpc_name }-nagios"
  description = "nagios master servers"
  vpc_id = "${ aws_vpc.main.id }"

  tags {
      Name = "${ var.vpc_name }-nagios"
  }
}


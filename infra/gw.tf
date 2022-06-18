#
# The SSH server
#

module "appliance_gw" {
    name = "gw"
    source = "./appliance"
    vpc_name = var.vpc_name
    key_name = aws_key_pair.ssh.key_name
    security_group_ids = [
        aws_security_group.main.id,
        aws_security_group.gw.id
    ]
    instance_ami = data.aws_ami.main.id
    subnet_id = aws_subnet.dmz.id
    private_zone_id = aws_route53_zone.private.id
    private_domain_name = aws_route53_zone.private.name
}

module "public_gw" {
    source = "./public_endpoint"
    service_hostname = "gw"
    instance_id = module.appliance_gw.instance_id
    zone_id = data.aws_route53_zone.main.id
}


resource "aws_security_group" "gw" {
  name        = "gw-${ var.vpc_name }"
  description = "SSH bastion host whitelist."
  vpc_id = aws_vpc.main.id
  tags = {
      Name = "gw-${ var.vpc_name }"
  }
}

resource "aws_security_group_rule" "external_ssh_to_gw" {
    type              = "ingress"
    from_port         = 22
    to_port           = 22
    protocol          = "tcp"
    cidr_blocks       = var.ssh_trusted_cidrs
    security_group_id = aws_security_group.gw.id
}


resource "aws_security_group_rule" "ssh_from_gw" {
    type              = "ingress"
    from_port         = 22
    to_port           = 22
    protocol          = "tcp"
    security_group_id = aws_security_group.main.id
    source_security_group_id = aws_security_group.gw.id
}


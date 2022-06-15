#
# Everything relating to the development machine is here.
#

module "appliance_devbox" {
    name = "devbox"
    source = "./appliance"
    volume_size = 32 # GiB
    vpc_name = var.vpc_name
    key_name = aws_key_pair.ssh.key_name
    security_group_ids = [aws_security_group.main.id]
    instance_ami = data.aws_ami.main.id
    subnet_id = aws_subnet.infra.id
    private_zone_id = aws_route53_zone.private.id
    private_domain_name = aws_route53_zone.private.name
}


#
# A monitoring machine, to monitor the rest of the fleet.
#

module "appliance_monitor" {
    name = "monitor"
    source = "./appliance"
    # limiting factor here is definitely main memory.
    # Running on a t3a.small, with 2 GiB, you run out before you've even installed all the components.
    instance_type = "t3a.medium"
    volume_size = 12 # GiB
    vpc_name = var.vpc_name
    key_name = aws_key_pair.ssh.key_name
    security_group_ids = [aws_security_group.main.id]
    instance_ami = data.aws_ami.main.id
    subnet_id = aws_subnet.infra.id
    private_zone_id = aws_route53_zone.private.id
    private_domain_name = aws_route53_zone.private.name
}


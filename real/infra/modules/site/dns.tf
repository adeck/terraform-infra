

#### public DNS resolution

data "aws_route53_zone" "public" {
    name = "${ var.domain }"
}

#### private DNS resolution

resource "aws_route53_zone" "private" {
    name = "${ var.private_domain }"
    vpc_id = "${ aws_vpc.main.id }"
}

resource "aws_vpc_dhcp_options" "main" {
    domain_name = "${ var.private_domain }"
    domain_name_servers = ["169.254.169.253"]
}

resource "aws_vpc_dhcp_options_association" "main" {
  vpc_id          = "${ aws_vpc.main.id }"
  dhcp_options_id = "${ aws_vpc_dhcp_options.main.id }"
}



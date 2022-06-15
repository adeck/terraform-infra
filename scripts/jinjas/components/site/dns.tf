

#### public DNS resolution

data "aws_route53_zone" "public" {
    name = "{{ domain.public }}"
}

#### private DNS resolution

resource "aws_route53_zone" "private" {
    name = "{{ domain.private }}"
    vpc_id = "${ aws_vpc.main.id }"
}

resource "aws_vpc_dhcp_options" "main" {
    domain_name = "{{ domain.private }}"
    domain_name_servers = ["169.254.169.253"]
}

resource "aws_vpc_dhcp_options_association" "main" {
  vpc_id          = "${ aws_vpc.main.id }"
  dhcp_options_id = "${ aws_vpc_dhcp_options.main.id }"
}



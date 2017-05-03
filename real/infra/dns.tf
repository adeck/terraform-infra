
data "aws_route53_zone" "main" {
    name = "${ var.domain }"
}

resource "aws_route53_zone" "infra" {
    name = "infra.${ var.domain }"
}


resource "aws_route53_record" "infra-ns" {
  zone_id = "${ data.aws_route53_zone.main.zone_id }"
  name    = "${ aws_route53_zone.infra.name }"
  type    = "NS"
  ttl     = "60"

  records = ["${ aws_route53_zone.infra.name_servers }"]
}

# for internal / private DNS resolution
resource "aws_route53_zone" "private" {
    name = "${ var.domain }"
    vpc_id = "${ aws_vpc.main.id }"
}

resource "aws_vpc_dhcp_options" "main" {
    domain_name = "${ var.domain }"
    domain_name_servers = ["169.254.169.253"]
}

resource "aws_vpc_dhcp_options_association" "main" {
  vpc_id          = "${ aws_vpc.main.id }"
  dhcp_options_id = "${ aws_vpc_dhcp_options.main.id }"
}



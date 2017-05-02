
resource "aws_route53_zone" "main" {
    name = "${ var.domain }"
}

resource "aws_route53_record" "adeck_testing" {
  zone_id = "${ aws_route53_zone.main.zone_id }"
  name    = "adeck-testing"
  type    = "A"
  ttl     = "300"
  records = ["${ aws_instance.adeck_testing.public_ip }"]
  #records = ["127.0.0.2"]
}




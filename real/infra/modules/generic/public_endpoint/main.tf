
resource "aws_route53_record" "main" {
  zone_id = "${ var.zone_id }"
  name    = "${ var.name }"
  type    = "A"
  ttl     = "300"
  records = ["${ aws_eip.main.public_ip }"]
}

resource "aws_eip" "main" {
    instance = "${ var.instance_id }"
    vpc      = true
}


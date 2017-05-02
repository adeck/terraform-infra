
resource "aws_route53_zone" "infra" {
    name = "${ var.domain }"
}



resource "aws_route53_record" "public" {
  zone_id = "${ var.public_domain_id }"
  name    = "${ var.service_dns }"
  type    = "A"
  ttl     = "300"
  records = ["${ aws_eip.main.public_ip }"]
}

resource "aws_route53_record" "private" {
  zone_id = "${ var.private_domain_id }"
  name    = "${ var.name }-infra"
  type    = "A"
  ttl     = "60"
  records = ["${ aws_instance.main.private_ip }"]
}

resource "aws_eip" "main" {
    instance = "${ aws_instance.main.id }"
    vpc      = true
}

data "template_file" "main" {
    template = "${ file("${path.module}/cloudinit.yml") }"
    vars {
        hostname = "${ var.name }-infra.${ var.private_domain_name }"
    }
}

resource "aws_instance" "main" {
  ami           = "${ var.instance_ami }"
  instance_type = "t2.micro"
  key_name = "${ var.key_name }"
  associate_public_ip_address = true
  vpc_security_group_ids = ["${ var.security_group_ids }"]
  subnet_id = "${ var.subnet_id }"
  user_data = "${ data.template_file.main.rendered }"
  tags {
    Name = "${ var.vpc_name }-${ var.name }"
    Description = "Managed by terraform"
  }
}


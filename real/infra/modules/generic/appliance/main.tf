
resource "aws_route53_record" "private" {
  zone_id = "${ var.private_zone_id }"
  name    = "${ var.service_name }"
  type    = "A"
  ttl     = "60"
  records = ["${ aws_instance.main.private_ip }"]
}

resource "aws_instance" "main" {
  ami           = "${ var.ami_id }"
  instance_type = "t2.micro"
  key_name = "${ var.key_name }"
  # if specified "false", and an EIP gets associated, the resource will be recreated every time.
  # associate_public_ip_address = false
  vpc_security_group_ids = ["${ var.security_group_ids }"]
  subnet_id = "${ var.subnet_id }"
  user_data = "${ data.template_file.cloudinit.rendered }"
  iam_instance_profile = "${ var.iam_profile }"
  tags {
    Name = "${ var.service_name }"
    Description = "Managed by terraform"
  }
}

data "template_file" "cloudinit" {
    template = "${ file("${path.module}/cloudinit.yml") }"
    vars {
        hostname = "${ var.service_name }.${ var.private_domain_name }"
    }
}


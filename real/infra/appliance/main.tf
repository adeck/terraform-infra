
resource "aws_route53_record" "private" {
  zone_id = var.private_zone_id
  name    = var.name
  type    = "A"
  ttl     = "60"
  records = [aws_instance.main.private_ip]
}

resource "aws_instance" "main" {
  ami           = var.instance_ami
  instance_type = var.instance_type
  key_name = var.key_name
  vpc_security_group_ids = var.security_group_ids
  subnet_id = var.subnet_id
  user_data = templatefile("${path.module}/cloudinit.yaml", {
    hostname = "${ var.name }.${ var.private_domain_name }"
  })
  root_block_device {
    volume_size = var.volume_size
  }
  tags = {
    Name = "${ var.name }-${ var.vpc_name }"
    Description = "Managed by terraform"
  }
  # Making this explicit actually introduces a bug, because by default no public IP is assigned, but for a public endpoint this will *become* true, so every subsequent apply run will recreate all public instances.
  # associate_public_ip_address = false # making it explicit
}


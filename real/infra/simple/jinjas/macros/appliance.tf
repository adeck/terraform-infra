{% macro appliance(name, subnet, security_group=False, iam_profile=False) %}

{% if subnet == "dmz" %}
resource "aws_route53_record" "main" {
  zone_id = "${ data.aws_route53_zone.public.id }"
  name    = "{{ name }}"
  type    = "A"
  ttl     = "300"
  records = ["${ aws_eip.{{ name }}.public_ip }"]
}

resource "aws_eip" "{{ name }}" {
    instance = "${ aws_instance.{{ name }}.id }"
    vpc      = true
}
{% endif %}

resource "aws_route53_record" "{{ name }}_private" {
  zone_id = "${ aws_route53_zone.private.id }"
  name    = "{{ name }}"
  type    = "A"
  ttl     = "60"
  records = ["${ aws_instance.{{ name }}.private_ip }"]
}

resource "aws_instance" "{{ name }}" {
  ami           = "${ data.aws_ami.main.id }"
  instance_type = "t2.micro"
  key_name = "${ aws_key_pair.main.key_name }"
  # if specified "false", and an EIP gets associated, the resource will be recreated every time.
  # associate_public_ip_address = false
  vpc_security_group_ids = [
      "${ aws_security_group.main.id }"
      {% if security_group %}
      ,"${ aws_security_group.{{ security_group }}.id }"
      {% endif %}
    ]
  subnet_id = "${ aws_subnet.{{ subnet }}.id }"
  user_data = "${ data.template_file.cloudinit.rendered }"
  {% if iam_profile %}
    iam_instance_profile = "{{ iam_profile }}"
  {% endif %}
  tags {
    Name = "{{ name }}"
    Description = "Managed by terraform"
  }
}

data "template_file" "cloudinit" {
    template = "${ file("${path.module}/files/cloudinit.yml") }"
    vars {
        hostname = "{{ name }}.{{ domain.private }}"
    }
}

{% endmacro %}

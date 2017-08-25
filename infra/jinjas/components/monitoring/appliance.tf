
{% import "macros/appliance.tf" as m with context %}

{{ m.appliance('monitoring-infra', subnet="infra",
        security_group="monitoring",
        iam_profile="${ aws_iam_instance_profile.monitoring.name }") }}



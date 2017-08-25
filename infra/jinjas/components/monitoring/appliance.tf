
{% import "macros/appliance.tf" as m with context %}

{{ m.appliance('monitoring-infra', subnet="infra", security_group="monitoring") }}




{% import "macros/appliance.tf" as m with context %}

{{ m.appliance('salt-infra', subnet="infra", security_group="salt") }}



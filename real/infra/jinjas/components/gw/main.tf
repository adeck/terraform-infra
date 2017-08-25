
{% import "macros/appliance.tf" as m with context %}

{{ m.appliance('gw-infra', subnet="dmz", security_group="gw") }}



#!/usr/bin/env bash
#
# prints the IP address of the bastion host
#

jq < infra/terraform.tfstate '
    .resources[]
    | select(.type == "aws_eip" and .module == "module.public_gw")
    | .instances[0].attributes.public_ip
' | tr -d '"'


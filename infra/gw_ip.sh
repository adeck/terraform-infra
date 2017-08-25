#!/usr/bin/env bash
#
# prints the IP address of the bastion host
#

jq < terraform/terraform.tfstate '
  .modules | .[] 
    | select(.path[0] == "root")
    | .resources."aws_eip.gw-infra".primary.attributes.public_ip
' | tr -d '"'


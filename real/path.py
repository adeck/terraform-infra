#!/usr/bin/env python

import json
from sys import argv

with open('%s/terraform.tfstate' % argv[1], 'r') as f:
  data = json.loads(f.read())

for module in data["modules"]:
  if "public_gw" in module["path"]:
    print module["resources"]["aws_eip.main"]["primary"]["attributes"]["public_ip"]


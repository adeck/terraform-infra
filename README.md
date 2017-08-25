# terraform-infra

Where I keep terraform infrastructure layouts.
Like a lot of other people out there, I find the namespace scoping / file layout issues of the terraform module system too restrictive.
So, like a lot of other people, I'm evaluating jinja2 templates with variables populated from a YAML file to generate the HCL templates that then get run.

This assumes you own an AMI called `debian-stretch-base`, based on the latest debian stretch AMI released by debian.

# How do I run this?

First, install terraform.
Then you may want to work inside a python virtualenv (I recommend `virtualenvwrapper` for this), but either way...

    cd infra
    pip install -r requirements.txt
    # copy the example configuration
    cp -r envs/example/ envs/devel/
    # make the necessary changes to that configuration
    vim envs/devel/
    ./build.py envs/devel/
    cd terraform
    terraform plan
    terraform apply
    cd ..
    ssh -A "admin@$(./gw_ip.sh | tr -d '\n')"

Now you'll find yourself on a host called `gw-infra`.
From there you can ssh to one of the two other hosts this thing created (e.g. via `ssh monitoring-infra`).
The other hosts are called `monitoring-infra` and `salt-infra`.
Since this repo is just for terraform, those other hosts aren't really configured, but DNS is, so you don't need to know IPs.


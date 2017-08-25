# terraform-infra

Where I keep terraform infrastructure layouts.
Like a lot of other people out there, I find the namespace scoping / file layout issues of the terraform module system too restrictive.
So, like a lot of other people, I'm evaluating jinja2 templates with variables populated from a YAML file to generate the HCL templates that then get run.

This assumes you own an AMI called `debian-stretch-base`, based on the latest debian stretch AMI released by debian.

# How do I run this?

First, install [`terraform`][terraform] and [`jq`][jq].
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

Technically, you don't even need to know the IP for the gateway host, because if you've setup DNS correctly you should just be able to go to `gw.<yourdomain.com>`, but given how long it takes DNS stuff to propagate, if you tore down the environment and then recreated you'd have to wait minutes before that DNS record would work again.
Hence the `gw_ip.sh` script.

[terraform]: https://www.terraform.io/
[jq]: https://stedolan.github.io/jq/


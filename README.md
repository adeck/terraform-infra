# terraform-infra

Where I keep terraform infrastructure layouts.

There's only one terraform layout in here at the moment.
It's a toy environment with three AWS EC2 instances:

1. SSH gateway host (`gw`) -- This is the only one with a public IP address. You SSH into this host, and from there you can SSH into the other two. Size `t3.micro`.
2. Monitoring host (`monitor`) -- This one's beefier, because it's meant to run an Elastic / ELK monitoring stack, and I chose the smallest host that would be able to install + run those components. Size `t3a.medium`.
3. Development host (`devbox`) -- Used for whatever. Developing whatever it is you'd want to develop. Also a `t3.micro`.

![Architecture diagram](/arch_diagram.svg)

Running this on the west coast runs >$70 / mo., so I wouldn't recommend running it long-term.
The only reason I'm using AWS at the moment is to quickly iterate on designs that I actually plan on deploying bare metal.
The platform is very nice and feature-rich, but prohibitively expensive for home projects.

# How do I run this?

First, install [`terraform`][terraform].
Then run these steps:

    cd infra
    cp terraform.tfvars.example terraform.tfvars
    # use whatever text editor you normally use to edit terraform.tfvars
    # follow the instructions in that file
    vim terraform.tfvars 
    terraform init
    # You don't actually need to run `plan` first,
    #   but it's always a good idea to validate what you'll be doing.
    # Also, for these two commands, you'll need to enter your AWS secret.
    #   You'll also need to confirm by typing "yes" for the "apply" command.
    terraform plan
    terraform apply

Then change your SSH config to resemble what's below:

    # replace `example.com` with the domain name you used in the terraform.tfvars file
    Host gw
        Hostname gw.example.com
        User admin

    Host devbox monitor
        ProxyJump gw
        # if you changed the VPC name to something other than `devel`, change that here
        HostName %h.devel.local
        User admin

Now you should be able to SSH into the SSH gateway / jump host by running:

    ssh gw

Now you'll find yourself on a host called `gw`.
You can connect to the other hosts (`monitor` and `devbox`, respectively) the same way you connected to `gw`, by running SSH from your local machine.
Since this repo is just for terraform, those other hosts aren't really configured, but DNS is, so you don't need to know IPs.

Once you are already SSH'd into `gw`, you could SSH to the other hosts from the commandline on the `gw` host.
However:

1. You would need to login to the `gw` host with the command `ssh -A gw`, but more importantly...
2. There's a security implication to doing this. That would be the `ForwardAgent` configuration, rather than the `JumpHost` configuration. It's the difference between allowing the gateway host to impersonate you to other machines v. creating an end-to-end encrypted tunnel and simply using the SSH gateway host as a hop along that path.

# How do I undo the above?

When you're done playing with the environment, run:

    terraform destroy

Like the `apply` subcommand, you will need to have your AWS secret key on hand and you'll need to type "yes" to confirm that you really want to destroy the AWS resources you created earlier.
Note that the `destroy` command will **only** destroy resources that were created by terraform during the above run.
It will **not** destroy the Route 53 zone you had for your domain, nor will it destroy anything else.

You should also remove the entries created in `~/.ssh/known_hosts` for the hosts you SSH'd into.
And obviously if you don't want to continue playing with these environments, remove the relevant bits from your `~/.ssh/config`.

# Bypassing DNS / SSHing using the gateway IP address

As you can see from the above, you don't need to know the IP for the gateway host.
You can simply SSH to `gw.<yourdomain.com>`.
However, given how long it takes DNS stuff to propagate, if you tore down the environment and then recreated you'd have to wait minutes before that DNS record would work again.
Hence the `gw_ip.sh` script, which simply reads the `.tfstate` file and writes the IP address for the gateway host to stdout.

So if you want to SSH to the gateway host without waiting for the DNS info to propagate you would run:

    # run this from the root directory of the repo
    cd scripts/
    # NOTE: you may want to run the following step within a python virtualenv. See the end of this guide.
    pip install -r requirements.txt
    ssh "admin@$(./gw_ip.sh | tr -d '\n')"

## Python virtualenvs

Python has its own package manager called `pip`.
The `gw_ip.sh` script uses a python tool called [`jq`][]
That tool is distributed as a pip package which you may not want to install globally.
If you just want to install it into a local directory, check out the [official python docs][] on virtualenvs.

Short version? To create a virtualenv to install stuff into, run:

    python3 -m venv /path/to/new/virtual/environment

To "enter" that virtualenv run:

    . /path/to/new/virtual/environment/bin/activate

To "leave" that virtualenv run:

    deactivate

[terraform]: https://www.terraform.io/
[official python docs]: https://docs.python.org/3/library/venv.html#creating-virtual-environments
[`jq`]: https://stedolan.github.io/jq/



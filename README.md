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

Congratulations! You are now logged in to the gateway host, named `gw`.
To connect to the other hosts (`monitor` and `devbox`, respectively) you will need to switch to a different terminal window, since you cannot log in to those hosts from the `gw` host itself.
Otherwise the commands would be the same, to wit:

    ssh monitor

And:

    ssh devbox

Since this repo is just for terraform, those other hosts aren't really configured. But DNS is configured, which is why you don't need to know IPs.

By default, you cannot log into `monitor` and `devbox` by running an SSH comand from the `gw` host.
The reason for this is that the `gw` host does not have access to your forwarding agent, and cannot impersonate you.
To make that possible, log into `gw` using the command `ssh -A gw`.

Worth noting that I did **not** make this the default because there is a security implication to doing this.
That would be the `ForwardAgent` configuration, rather than the `JumpHost` configuration.
It's the difference between allowing the gateway host to impersonate you to other machines v. creating an end-to-end encrypted tunnel and simply using the SSH gateway host as a hop along that path.

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

So if you want to SSH to the gateway host without waiting for the DNS info to propagate you would first install [`jq`][], then run:

    # run this from the root directory of the repo
    ssh "admin@$(./scripts/gw_ip.sh | tr -d '\n')"

On a related note, the `gw_ip.sh` script is super short and (imho) pretty cool.
Because `jq` is pretty cool.
Strongly recommend giving it a glance.

[terraform]: https://www.terraform.io/
[`jq`]: https://stedolan.github.io/jq/



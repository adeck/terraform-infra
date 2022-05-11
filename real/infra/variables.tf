
variable "access_key" {type = string}
variable "secret_key" {type = string}
variable "geo" {
    type = string
    default = "us-west-1"
}

variable "vpc_cidr" {type = string}
variable "vpc_name" {type = string}

variable "domain" {type = string}

variable "ssh_trusted_cidrs" {type = list(string)}

variable "public_key" {type = string}


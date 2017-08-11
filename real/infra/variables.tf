
variable "access_key" {}
variable "secret_key" {}
variable "geo" {
    default = "us-west-1"
}

variable "vpc_cidr" {}
variable "vpc_name" {}

variable "domain" {}
variable "private_domain" {
  default = "private"
}

variable "trusted_cidr" {}

variable "public_key" {}


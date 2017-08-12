
provider "aws" {
  access_key = "${ var.access_key }"
  secret_key = "${ var.secret_key }"
  region = "${ var.geo }"
}

module "site" {
  source = "modules/site"
  vpc_name = "${ var.vpc_name }"
  vpc_cidr = "${ var.vpc_cidr }"
  domain = "${ var.domain }"
  private_domain = "${ var.private_domain }"
  public_key = "${ var.public_key }"
}

module "gw" {
  source = "modules/infra/gw"
  vpc_name = "${ var.vpc_name }"
  vpc_id = "${ module.site.vpc_id }"
  ami_id = "${ module.site.default_ami_id }"
  key_name = "${ module.site.key_name }"
  default_sg_id = "${ module.site.default_sg_id }"
  trusted_cidr = "${ var.trusted_cidr }"
  subnet_id = "${ module.site.dmz_subnet_id }"
  public_zone_id = "${ module.site.public_zone_id }"
  private_zone_id  = "${ module.site.private_zone_id }"
  private_domain_name = "${ var.private_domain }"
}

module "salt" {
  source = "modules/infra/salt"
  vpc_name = "${ var.vpc_name }"
  vpc_id = "${ module.site.vpc_id }"
  ami_id = "${ module.site.default_ami_id }"
  key_name = "${ module.site.key_name }"
  default_sg_id = "${ module.site.default_sg_id }"
  subnet_id = "${ module.site.infra_subnet_id }"
  private_zone_id  = "${ module.site.private_zone_id }"
  private_domain_name = "${ var.private_domain }"
}

module "monitoring" {
  source = "modules/infra/monitoring"
  vpc_name = "${ var.vpc_name }"
  vpc_id = "${ module.site.vpc_id }"
  ami_id = "${ module.site.default_ami_id }"
  key_name = "${ module.site.key_name }"
  default_sg_id = "${ module.site.default_sg_id }"
  ingress_sg_id = "${ module.gw.sg_id }"
  subnet_id = "${ module.site.infra_subnet_id }"
  private_zone_id  = "${ module.site.private_zone_id }"
  private_domain_name = "${ var.private_domain }"
}




variable "lambda_archive" {}
variable "runtime" {}
variable "function_subdomain" {}
variable "name" {}
variable "handler" {}
variable "base_domain" {}
variable "envvars" {
  type    = map(string)
  default = {}
}
data aws_route53_zone "base_domain" {
  name = local.base_domain
}
variable "memory_size" {
  default = 1024
}
variable "timeout" {
  default = 60
}
data aws_caller_identity "current" {}
data "aws_region" "current" {}

locals {
  name           = var.name
  base_domain    = var.base_domain
  domain_zone_id = data.aws_route53_zone.base_domain.zone_id
  account_id     = data.aws_caller_identity.current.account_id
  hostname       = "${var.function_subdomain}.${local.base_domain}"
  region         = data.aws_region.current.name
  lambda_archive = var.lambda_archive
  runtime        = var.runtime
  handler        = var.handler
  memory_size    = var.memory_size
  timeout        = var.timeout
  envvars = merge({
    NAME   = var.name,
    MODULE = "LambdaDeployment v0.1.0"
  }, var.envvars)
}

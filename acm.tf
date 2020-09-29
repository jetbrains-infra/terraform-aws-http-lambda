module "certificate" {
  source  = "github.com/jetbrains-infra/terraform-aws-acm-certificate?ref=v0.3.0"
  name    = local.name
  region  = "us-east-1"

  aliases = [
    {
      hostname = local.hostname
      zone_id  = local.domain_zone_id
    }
  ]
}

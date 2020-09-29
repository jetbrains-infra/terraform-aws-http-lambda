resource "aws_route53_record" "function" {
  name    = local.hostname
  type    = "A"
  zone_id = local.domain_zone_id

  alias {
    name                   = aws_cloudfront_distribution.function.domain_name
    zone_id                = aws_cloudfront_distribution.function.hosted_zone_id
    evaluate_target_health = false
  }
}

resource "aws_cloudfront_distribution" "function" {
  enabled = true
  aliases = [local.hostname]

  origin {
    custom_origin_config {
      http_port                = 80
      https_port               = 443
      origin_protocol_policy   = "https-only"
      origin_keepalive_timeout = 30
      origin_ssl_protocols = [
        "TLSv1",
        "TLSv1.1",
        "TLSv1.2"
      ]
    }

    domain_name = "${aws_apigatewayv2_api.function.id}.execute-api.${local.region}.amazonaws.com"
    origin_id   = "func"
  }

  default_cache_behavior {
    allowed_methods        = ["HEAD", "DELETE", "POST", "GET", "OPTIONS", "PUT", "PATCH"]
    cached_methods         = ["GET", "HEAD"]
    default_ttl            = 0
    max_ttl                = 0
    min_ttl                = 0
    compress               = true
    target_origin_id       = "func"
    trusted_signers        = []
    viewer_protocol_policy = "redirect-to-https"

    forwarded_values {
      cookies {
        forward           = "all"
        whitelisted_names = []
      }
      query_string            = true
      query_string_cache_keys = []
      headers = [
        "Accept",
        "Authorization",
        //        "Host",  <---- we cannot forward custom Host due to API GW expects own one
        "Origin",
        "Referer"
      ]
    }
  }

  custom_error_response {
    error_caching_min_ttl = 0
    error_code            = 404
  }

  custom_error_response {
    error_caching_min_ttl = 0
    error_code            = 403
  }

  custom_error_response {
    error_caching_min_ttl = 10
    error_code            = 500
  }

  custom_error_response {
    error_caching_min_ttl = 10
    error_code            = 502
  }

  custom_error_response {
    error_caching_min_ttl = 30
    error_code            = 503
  }

  custom_error_response {
    error_caching_min_ttl = 30
    error_code            = 504
  }

  restrictions {
    geo_restriction {
      locations        = []
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn      = module.certificate.arn
    minimum_protocol_version = "TLSv1"
    ssl_support_method       = "sni-only"
  }
}
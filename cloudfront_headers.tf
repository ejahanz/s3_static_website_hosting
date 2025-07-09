resource "aws_cloudfront_response_headers_policy" "security_headers_policy" {
  name = "SecurityHeadersPolicy"

  security_headers_config {
    content_security_policy {
      override = true
      content_security_policy = "default-src 'self'; script-src 'self'; style-src 'self' 'unsafe-inline'; img-src 'self' https://cloudkraft-site.s3.ap-southeast-2.amazonaws.com; object-src 'none'; font-src 'self' data:; frame-ancestors 'none'; base-uri 'self'; form-action 'self';"
    }

    content_type_options {
      override = true
    }

    frame_options {
      frame_option = "DENY"
      override     = true
    }

    referrer_policy {
      referrer_policy = "strict-origin-when-cross-origin"
      override         = true
    }

    strict_transport_security {
      access_control_max_age_sec = 63072000
      include_subdomains         = true
      preload                    = true
      override                   = true
    }

    xss_protection {
      protection = true
      mode_block = true
      override   = true
    }
  }

  custom_headers_config {
    items {
      header   = "Permissions-Policy"
      value    = "geolocation=(), microphone=(), camera=(), payment=(), usb=(), magnetometer=(), gyroscope=(), speaker=()"
      override = true
    }
  }
}

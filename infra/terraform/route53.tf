data "aws_route53_zone" "main" {
  name         = "plugfolio.cloud"
  private_zone = false
}

resource "aws_route53_record" "medusa_app" {
  zone_id = data.aws_route53_zone.main.zone_id
  name    = "plugfolio.cloud"
  type    = "A"

  alias {
    name                   = aws_lb.medusa_alb.dns_name
    zone_id                = aws_lb.medusa_alb.zone_id
    evaluate_target_health = true
  }
}

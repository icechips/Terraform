#private zone creation
resource "aws_route53_zone" "bakery_private_zone" {
  name = "${local.App}.${var.EnvName}.ca"

  vpc {
    vpc_id = var.vpc_id
  }

  tags = {
    Env  = var.EnvName,
    App  = local.App
  }
}
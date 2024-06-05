#ALB creation
resource "aws_lb" "bakery_alb" {
  name                             = "${local.ClientName}-${var.EnvName}-${local.App}"
  internal                         = true
  load_balancer_type               = "application"
  security_groups                  = var.alb_security_groups
  enable_cross_zone_load_balancing = true
  subnets                          = var.subnet_ids
  
  #mandatory in the account, bakery controlled values, can build the alb with this block commented out, then add in and look at plan diff for vaules
  access_logs {
      bucket  = var.access_logs_bucket
      prefix  = var.access_logs_prefix
      enabled = true
  }
  
  tags = {
    Name = "${local.ClientName}-${var.EnvName}-${local.App}",
    Env  = var.EnvName,
    App  = local.App
  }
}

#ALB target group creation
resource "aws_lb_target_group" "bakery_alb_target_group_port1" {
  name        = "${local.ClientName}-${var.EnvName}-${local.App}-target-group-${var.bakery_traffic_port_1}"
  target_type = "instance"
  port        = var.bakery_traffic_port_1
  protocol    = "HTTP"
  vpc_id      = var.vpc_id

  health_check {
    port                = 800
    protocol            = "HTTP"
    path                = "/health_check.php"
    healthy_threshold   = "5"
    matcher             = "200"
    unhealthy_threshold = "2"
  }

  tags = {
    Name = "${local.ClientName}-${var.EnvName}-${local.App}-target-group-${var.bakery_traffic_port_1}",
    Env  = var.EnvName,
    App  = local.App
  }
}

resource "aws_lb_target_group" "bakery_alb_target_group_port2" {
  name        = "${local.ClientName}-${var.EnvName}-${local.App}-target-group-${var.bakery_traffic_port_2}"
  target_type = "instance"
  port        = var.bakery_traffic_port_2
  protocol    = "HTTP"
  vpc_id      = var.vpc_id

  health_check {
    port                = 800
    protocol            = "HTTP"
    path                = "/health_check.php"
    healthy_threshold   = "5"
    matcher             = "200"
    unhealthy_threshold = "2"
  }

  tags = {
    Name = "${local.ClientName}-${var.EnvName}-${local.App}-target-group-${var.bakery_traffic_port_2}",
    Env  = var.EnvName,
    App  = local.App
  }
}

#ALB listeners creation
resource "aws_lb_listener" "bakery_lb_listener_port1" {
  load_balancer_arn = aws_lb.bakery_alb.id
  port              = var.bakery_traffic_port_1
  protocol          = "HTTP"
  #certificate_arn   = var.certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.bakery_alb_target_group_port1.id
  }
}

resource "aws_lb_listener" "bakery_lb_listener_port2" {
  load_balancer_arn = aws_lb.bakery_alb.id
  port              = var.bakery_traffic_port_2
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.bakery_alb_target_group_port2.id
  }
}

#ALB target group attachment
#to be commented out if importing alb module, since this resource does not support importing. 
/*resource "aws_lb_target_group_attachment" "bakery_alb_target_group_attach_port1" {
  for_each = toset(var.instance_ids)

  target_group_arn = aws_lb_target_group.bakery_alb_target_group_port1.arn
  target_id        = each.value
  port             = 800
}

resource "aws_lb_target_group_attachment" "bakery_alb_target_group_attach_port2" {
  for_each = toset(var.instance_ids)

  target_group_arn = aws_lb_target_group.bakery_alb_target_group_port2.arn
  target_id        = each.value
  port             = 800
}*/
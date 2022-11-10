resource "aws_lb" "alb" {
  name               = "${var.name}-lb2"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb_sg.id]
  subnets            = var.public_subnet

  enable_deletion_protection = true

}

resource "aws_lb_target_group" "tg" {
  name     = "${var.name}-tg2"
  port     = var.port
  protocol = "HTTPS"
  vpc_id   = var.vpc_id
}

resource "aws_lb_target_group_attachment" "attach_tg" {
  target_group_arn = aws_lb_target_group.tg.arn
  target_id        = aws_instance.ec2_websrv.id
  port             = var.port
}

resource "aws_lb_listener" "ec2_listener" {
  load_balancer_arn = aws_lb.alb.arn
  port              = var.port
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-FS-1-2-Res-2020-10"
  certificate_arn   = "arn:aws:acm:us-east-2:313401190557:certificate/cc1aa7c9-297e-4721-b8e5-0e3e579a2895"

  default_action {
    target_group_arn = aws_lb_target_group.tg.id
    type             = "forward"
  }
}
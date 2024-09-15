# The purpose of this file is to set up the configuration of the load balancer
# that will be used to distribute the traffic to the ECS cluster an will have
# certain configurations.


resource "aws_lb" "ecs_lb" {
    name            = "ecs-load-balancer"
    subnets         = aws_subnet.public.*.id
    security_groups = [aws_security_group.ecs_sg.id]
}

resource "aws_lb_target_group" "ecs_target_group_app" {
    name        = "ecs-target-group"
    port        = 80 
    protocol    = "HTTP"
    vpc_id      = aws_vpc.main.id
    target_type = "ip"

    health_check {
      healthy_threshold   = "2" 
      interval            = "30"
      protocol            = "HTTP"
      matcher             = "200"
      timeout             = "3"
      path                = var.check_health_path
      unhealthy_threshold = "2"
    }
}

# we need to create a listener to listen to the traffic 
# and forward that from the load balancer to the target group
resource "aws_lb_listener" "ecs_listener" {
    load_balancer_arn = aws_lb.ecs_lb.arn
    port              = var.container_port
    protocol          = "HTTP"

    default_action {
        target_group_arn = aws_lb_target_group.ecs_target_group_app.arn
        type             = "forward"
    }
}
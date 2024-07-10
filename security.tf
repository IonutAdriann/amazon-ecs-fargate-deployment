# ALB security group to add or restrict the access to the application 

resource "aws_security_group" "lb_sg" {
    name = "app-load-balancer-security-group"
    vpc_id = aws_vpc.id
    description = "security group to control access to and from the application load balancer"

    ingress {
        protocol  = "tcp"
        from_port = var.application_port
        to_port   = var.application_port
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        protocol = "-1" # allow all protocols
        from_port = 0
        to_port = 0
        cidr_blocks = ["0.0.0.0/0"]
    }
}

# Security group for the ECS cluster to control access to the containers from the ALB
resource "aws_security_group" "ecs_tasks_sg" {
    name = "ecs-tasks-security-group"
    vpc_id = aws_vpc.vpc_id
    description = "security group to control access to and from the ECS tasks"

    ingress {
        protocol = "tcp"
        from_port = var.application_port
        to_port = var.application_port
        security_groups = [aws_security_group.lb_sg.id]
    }

    egress {
        protocol = "-1"
        from_port = 0 
        to_port = 0 
        cidr_blocks = ["0.0.0.0/0"]
    }
}


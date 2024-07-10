# ALB security group to add or restrict the access to the application 

resource "aws_security_group" "lb_sg" {
    name = "app-load-balancer-security-group"
    vpc_id = aws_vpc.id
    description = "security group to control access to and from the application load balancer"

    ingress {
        protocol  = "tcp"
        from_port = var.application_port
        to_port   = var.application_port
        cidr_block = ["0.0.0.0/0"]
    }

    egress {
        protocol = "-1"
        
    }
}


# This file has the purpose of configuring the 
# resource especially for the cluster. 

resource "aws_ecs_cluster" "ecs_cluster" {
    name = "application-cluster"
}


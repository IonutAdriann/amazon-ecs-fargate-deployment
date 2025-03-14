# This file has the purpose of configuring the 
# resource especially for the cluster. 

resource "aws_ecs_cluster" "ecs_cluster" {
    name = "application-cluster"
}

data "template_file" "cb_application" {
    template = file("./templates/ecs/cb_app.json.tpl")

    vars = {
        app_image             = var.docker_image
        app_port              = var.application_port
        fg_container_cpu      = var.fargate_container_cpu
        aws_region            = var.aws_region
    } 
}
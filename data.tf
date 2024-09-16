data "template_file" "container_definitions" {
    template = file("${path.module}/container_definitions.json")

    vars = {
        ecr_image_url    = var.docker_image
        fargate_cpu      = var.fargate_container_cpu
        fargate_memory   = var.fargate_container_memory
        application_port = var.application_port
    }
}
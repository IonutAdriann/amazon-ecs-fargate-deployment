# the purpose of this file is to put all the variables that we need to use in the setup of this application

variable "aws_access_key" {
    description = "IAM public access key"   
}

variable "aws_secret_key" {
    description = "IAM secret access key"
}

variable "aws_region" {
    description = "Value of the region"
    default     = "eu-west-1"
}

variable "ec2_task_execution_role" {
    description = "IAM role name for ECS task execution"
    default     = "ecsTaskExecutionRole"
}

variable "ecs_auto_scaling_role" {
    description = "IAM role name for ECS auto scaling"
    default     = "myEcsAutoscaleRole"
}

variable "docker_image" {
    description = "Docker image to deploy"
}

variable "container_port" {
    description = "Port exposed by the container image to map to the host"
    default     = 80
}

variable "az_number" {
    description = "The number of availability zones to deploy the ECS cluster"
    default     = 2
}

variable "container_count" {
    description = "The number of containers to deploy and run"
    default     = 3
}

variable "check_health_path" {
    description = "The path to check the health of the container"
    default     = "/health"
}

variable "fargate_container_cpu" {
    description = "Value of the CPU to allocate to the container"
    default     = "1024"
}

variable "fargate_container_memory" {
    description = "Value of the memory to allocate to the container"
    default     = "2048"
}
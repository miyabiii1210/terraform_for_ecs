# ---------------------------
# ECS
# ---------------------------
# Cluster
resource "aws_ecs_cluster" "ecs-cluster" {
    name = "${var.project}-${var.environment}-${var.action}-ecs-cluster"

    setting {
        name  = "containerInsights"
        value = "enabled"
    }

    tags = {
        Name    = "${var.project}-${var.environment}-${var.action}-ecs-cluster"
        Project = var.project
        Env     = var.environment
    }
}

# Capacity Provider
resource "aws_ecs_cluster_capacity_providers" "cluster_capacity_providers" {
    cluster_name = aws_ecs_cluster.ecs-cluster.name

    capacity_providers = ["FARGATE"]

    default_capacity_provider_strategy {
        base              = 1
        weight            = 100
        capacity_provider = "FARGATE"
    }
}

# Task Definition
resource "aws_ecs_task_definition" "task_definition" {
    family = "${var.project}-${var.environment}-${var.action}-task_definition"
    requires_compatibilities = ["FARGATE"]
    network_mode             = "awsvpc"
    cpu                      = 2048
    memory                   = 4096
    task_role_arn            = aws_iam_role.ecs-task-role.arn
    execution_role_arn       = aws_iam_role.ecs-task-role.arn

    container_definitions = file("./task-definitions/sample.json")

    runtime_platform {
        operating_system_family = "LINUX"
        cpu_architecture        = "X86_64"
    }
}

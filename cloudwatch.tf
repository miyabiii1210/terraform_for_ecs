# ---------------------------
# CloudWatch
# ---------------------------
# Logs
resource "aws_cloudwatch_log_group" "cloudwatch_logs" {
    name              = "/ecs/${var.project}-${var.environment}-${var.action}-cloudwatch_logs"
    retention_in_days = 30

    tags = {
        Name    = "${var.project}-${var.environment}-${var.action}-cloudwatch-logs"
        Project = var.project
        Env     = var.environment
    }
}

# Event Rule
resource "aws_cloudwatch_event_rule" "event-rule" {
    name = "${var.project}-${var.environment}-${var.action}-event-rule"
    schedule_expression = "cron(0 0 * * ? *)" # JST 09:00
    # schedule_expression = "cron(0/5 * * * ? *)"
}

# Event Target
resource "aws_cloudwatch_event_target" "event-target" {
    target_id = "${var.project}-${var.environment}-${var.action}-event-target"
    rule      = aws_cloudwatch_event_rule.event-rule.name
    arn       = aws_ecs_cluster.ecs-cluster.arn
    role_arn  = aws_iam_role.ecs-events-role.arn

    ecs_target {
        launch_type         = "FARGATE"
        platform_version    = "LATEST"
        task_count          = 1
        task_definition_arn = aws_ecs_task_definition.task_definition.arn

        network_configuration {
            subnets          = [ aws_subnet.public-subnet-1a.id,aws_subnet.public-subnet-1c.id ]
            security_groups  = [ aws_security_group.main_security_group.id ]
            assign_public_ip = true
        }
    }
}
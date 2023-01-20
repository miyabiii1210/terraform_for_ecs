# ---------------------------
# IAM
# ---------------------------
data "aws_iam_policy_document" "assume_role" {
    statement {
        actions = ["sts:AssumeRole"]

        principals {
            type        = "Service"
            identifiers = ["ecs-tasks.amazonaws.com", "events.amazonaws.com"]
        }
    }
}

# Alternative role for ecsTaskExecutionRole
resource "aws_iam_role" "ecs-task-role" {
    name               = "${var.project}-${var.environment}-${var.action}-ecs-task-role"
    assume_role_policy = data.aws_iam_policy_document.assume_role.json

    tags = {
        Name    = "${var.project}-${var.environment}-ecs-task-role"
        Project = var.project
        Env     = var.environment
    }
}

resource "aws_iam_role_policy_attachment" "ecs_task_exec" {
    role       = aws_iam_role.ecs-task-role.name
    policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# Alternative role for ecsEventsRole
resource "aws_iam_role" "ecs-events-role" {
    name               = "${var.project}-${var.environment}-${var.action}-ecs-events-role"
    assume_role_policy = data.aws_iam_policy_document.assume_role.json

    tags = {
        Name    = "${var.project}-${var.environment}-${var.action}-ecs-events-role"
        Project = var.project
        Env     = var.environment
    }
}

resource "aws_iam_role_policy" "ecs-events-policy" {
    name   = "${var.project}-${var.environment}-${var.action}-ecs-events-policy"
    role   = aws_iam_role.ecs-events-role.id
    policy = file("./iam_list/ecs-events-role.json")
}

# ---------------------------
# ECR
# ---------------------------
resource "aws_ecr_repository" "aws-ecr" {
    name                 = "${var.project}-${var.environment}-${var.action}-ecr"
    image_tag_mutability = "MUTABLE"

    image_scanning_configuration {
        scan_on_push = false
    }

    encryption_configuration {
        encryption_type = "AES256"
    }

    tags = {
        Name    = "${var.project}-${var.environment}-${var.action}-ecr"
        Project = var.project
        Env     = var.environment
    }
}
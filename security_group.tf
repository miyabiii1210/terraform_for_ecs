# ---------------------------
# Security Group
# ---------------------------
resource "aws_security_group" "main_security_group" {
    name   = "${var.project}-${var.environment}-${var.action}-security-group"
    vpc_id = aws_vpc.main.id

    tags = {
        Name    = "${var.project}-${var.environment}-${var.action}-security-group"
        Project = var.project
        Env     = var.environment
    }
}

resource "aws_security_group_rule" "in-ssh" {
    security_group_id = aws_security_group.main_security_group.id
    type              = "ingress"
    protocol          = "tcp"
    from_port         = 22
    to_port           = 22
    cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "out-igw" {
    security_group_id = aws_security_group.main_security_group.id
    type              = "egress"
    protocol          = "all"
    from_port         = 0
    to_port           = 0
    cidr_blocks       = ["0.0.0.0/0"]
}
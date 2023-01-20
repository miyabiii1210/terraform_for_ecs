# ---------------------------
# VPC
# ---------------------------
resource "aws_vpc" "main" {
    cidr_block                       = "10.0.0.0/16"
    instance_tenancy                 = "default"
    enable_dns_support               = true
    enable_dns_hostnames             = true
    assign_generated_ipv6_cidr_block = false

    tags = {
        Name    = "${var.project}-${var.environment}-${var.action}-vpc"
        Project = var.project
        Env     = var.environment
    }
}

# ---------------------------
# Subnet (Public)
# ---------------------------
resource "aws_subnet" "public-subnet-1a" {
    vpc_id                  = aws_vpc.main.id
    availability_zone       = "ap-northeast-1a"
    cidr_block              = "10.0.0.0/20"
    map_public_ip_on_launch = true

    tags = {
        Name    = "${var.project}-${var.environment}-${var.action}-public-subnet-1a"
        Project = var.project
        Env     = var.environment
        Type    = "public"
    }
}

resource "aws_subnet" "public-subnet-1c" {
    vpc_id                  = aws_vpc.main.id
    availability_zone       = "ap-northeast-1c"
    cidr_block              = "10.0.16.0/20"
    map_public_ip_on_launch = true

    tags = {
        Name    = "${var.project}-${var.environment}-${var.action}-public-subnet-1c"
        Project = var.project
        Env     = var.environment
        Type    = "public"
    }
}

# ---------------------------
# Subnet (Private)
# ---------------------------
# resource "aws_subnet" "private-subnet-1a" {
#     vpc_id                  = aws_vpc.main.id
#     availability_zone       = "ap-northeast-1a"
#     cidr_block              = "10.0.128.0/20"
#     map_public_ip_on_launch = true

#     tags = {
#         Name    = "${var.project}-${var.environment}-${var.action}-private-subnet-1a"
#         Project = var.project
#         Env     = var.environment
#         Type    = "private"
#     }
# }

# resource "aws_subnet" "private-subnet-1c" {
#     vpc_id                  = aws_vpc.main.id
#     availability_zone       = "ap-northeast-1c"
#     cidr_block              = "10.0.144.0/20"
#     map_public_ip_on_launch = true

#     tags = {
#         Name    = "${var.project}-${var.environment}-${var.action}-private-subnet-1c"
#         Project = var.project
#         Env     = var.environment
#         Type    = "private"
#     }
# }

# ---------------------------
# Route Table (Public)
# ---------------------------
resource "aws_route_table" "public-route-table" {
    vpc_id = aws_vpc.main.id
    tags = {
        Name    = "${var.project}-${var.environment}-${var.action}-public-route-table"
        Project = var.project
        Env     = var.environment
        Type    = "public"
    }
}

resource "aws_route_table_association" "public-route-table-1a" {
    route_table_id = aws_route_table.public-route-table.id
    subnet_id      = aws_subnet.public-subnet-1a.id
}

resource "aws_route_table_association" "public-route-table-1c" {
    route_table_id = aws_route_table.public-route-table.id
    subnet_id      = aws_subnet.public-subnet-1c.id
}

# ---------------------------
# Route table (Private)
# ---------------------------
# resource "aws_route_table" "private-route-table" {
#     vpc_id = aws_vpc.main.id

#     tags = {
#         Name    = "${var.project}-${var.environment}-${var.action}-private-route-table"
#         Project = var.project
#         Env     = var.environment
#         Type    = "private"
#     }
# }

# resource "aws_route_table_association" "private-route-table-1a" {
#     route_table_id = aws_route_table.private-route-table.id
#     subnet_id      = aws_subnet.private-subnet-1a.id
# }

# resource "aws_route_table_association" "private-route-table-1c" {
#     route_table_id = aws_route_table.private-route-table.id
#     subnet_id      = aws_subnet.private-subnet-1c.id
# }

# ---------------------------
# Internet Gateway
# ---------------------------
resource "aws_internet_gateway" "internet-gateway" {
    vpc_id = aws_vpc.main.id

    tags = {
        Name    = "${var.project}-${var.environment}-${var.action}-internet-gateway"
        Project = var.project
        Env     = var.environment
    }
}

resource "aws_route" "public_route_table_internet_gateway" {
    route_table_id         = aws_route_table.public-route-table.id
    destination_cidr_block = "0.0.0.0/0"
    gateway_id             = aws_internet_gateway.internet-gateway.id
}

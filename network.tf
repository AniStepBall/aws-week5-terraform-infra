resource "aws_vpc" "main" {
    cidr_block           = var.vpc_cidr
    enable_dns_support   = true
    enable_dns_hostnames = true

    tags = {
        Name = "week5-vpc"
    }
}

resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.main.id

    tags = {
        Name = "week5-vpc"
    }
}

resource "aws_subnet" "public_a" {
    vpc_id                  = aws_vpc.main.id
    cidr_block              = var.public_subnet_a_cidr
    availability_zone       = "ca-central-1a"
    map_public_ip_on_launch = true

    tags = {
        Name = "week5-public-a"
    }
}

resource "aws_subnet" "public_b" {
    vpc_id                  = aws_vpc.main.id
    cidr_block              = var.public_subnet_b_cidr
    availability_zone       = "ca-central-1b"
    map_public_ip_on_launch = true

    tags = {
        Name = "week5-public-b"
    }
}

resource "aws_subnet" "private_a" {
    vpc_id                  = aws_vpc.main.id
    cidr_block              = var.private_subnet_a_cidr
    availability_zone       = "ca-central-1a"

    tags = {
        Name = "week5-private-a"
    }
}

resource "aws_subnet" "private_b" {
    vpc_id                  = aws_vpc.main.id
    cidr_block              = var.private_subnet_b_cidr
    availability_zone       = "ca-central-1b"

    tags = {
        Name = "week5-private-b"
    }
}

resource "aws_route_table" "public" {
    vpc_id = aws_vpc.main.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.igw.id
    }

    tags = {
        Name = "week5-public-rt"
    }
}

resource "aws_route_table_association" "public_a" {
    subnet_id       = aws_subnet.public_a.id
    route_table_id  = aws_route_table.public.id
}

resource "aws_route_table_association" "public_b" {
    subnet_id       = aws_subnet.public_b.id
    route_table_id  = aws_route_table.public.id
}

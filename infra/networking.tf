resource "aws_vpc" "main" {
  cidr_block           = "10.16.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
}

resource "aws_subnet" "db_1" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.16.0.0/20"
  availability_zone = "us-east-1a"
  tags = {
    Name = "journal-db-us-east-1a"
  }
}

resource "aws_subnet" "db_2" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.16.16.0/20"
  availability_zone = "us-east-1b"
  tags = {
    Name = "journal-db-us-east-1b"
  }
}

resource "aws_subnet" "app_1" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.16.32.0/20"
  availability_zone = "us-east-1a"
  tags = {
    Name                                        = "journal-app-us-east-1a"
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
  }
}

resource "aws_subnet" "app_2" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.16.48.0/20"
  availability_zone = "us-east-1b"
  tags = {
    Name                                        = "journal-app-us-east-1b"
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
  }
}

resource "aws_subnet" "public_1" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.16.64.0/20"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true
  tags = {
    Name                                        = "journal-public-us-east-1a"
    "kubernetes.io/role/elb"                    = "1"
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
  }
}

resource "aws_subnet" "public_2" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.16.80.0/20"
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = true
  tags = {
    Name                                        = "journal-public-us-east-1b"
    "kubernetes.io/role/elb"                    = "1"
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "journal-public-rt"
  }
}

resource "aws_route_table_association" "public_1_assoc" {
  subnet_id      = aws_subnet.public_1.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "public_2_assoc" {
  subnet_id      = aws_subnet.public_2.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table" "app_rt" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "journal-app-rt"
  }
}

resource "aws_route_table_association" "app_1_assoc" {
  subnet_id      = aws_subnet.app_1.id
  route_table_id = aws_route_table.app_rt.id
}

resource "aws_route_table_association" "app_2_assoc" {
  subnet_id      = aws_subnet.app_2.id
  route_table_id = aws_route_table.app_rt.id
}

resource "aws_route_table" "db_rt" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "journal-db-rt"
  }
}

resource "aws_route_table_association" "db_1_assoc" {
  subnet_id      = aws_subnet.db_1.id
  route_table_id = aws_route_table.db_rt.id
}

resource "aws_route_table_association" "db_2_assoc" {
  subnet_id      = aws_subnet.db_2.id
  route_table_id = aws_route_table.db_rt.id
}
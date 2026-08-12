# Security Group for Bastion Host
resource "aws_security_group" "bastion_sg" {
  name        = "journal-bastion-sg"
  description = "Security group for Bastion host"
  vpc_id      = aws_vpc.main.id

  tags = {
    Name = "journal-bastion-sg"
  }
}

# Bastion Outbound Rule
resource "aws_vpc_security_group_egress_rule" "bastion_outbound" {
  security_group_id = aws_security_group.bastion_sg.id

  ip_protocol = "-1"
  cidr_ipv4   = "0.0.0.0/0"

  description = "Allow all outbound traffic"
}

# Security Group for EKS Worker Nodes
resource "aws_security_group" "api_sg" {
  name        = "journal-api-sg"
  description = "Security group for EKS worker nodes"
  vpc_id      = aws_vpc.main.id

  tags = {
    Name = "journal-api-sg"
  }
}

# API Outbound Rule
resource "aws_vpc_security_group_egress_rule" "api_outbound" {
  security_group_id = aws_security_group.api_sg.id

  ip_protocol = "-1"
  cidr_ipv4   = "0.0.0.0/0"

  description = "Allow all outbound traffic"
}

# Security Group for RDS PostgreSQL
resource "aws_security_group" "db_sg" {
  name        = "journal-db-sg"
  description = "Allow PostgreSQL from Journal API"
  vpc_id      = aws_vpc.main.id

  tags = {
    Name = "journal-db-sg"
  }
}

# PostgreSQL Inbound Rules
resource "aws_vpc_security_group_ingress_rule" "api_inbound" {
  security_group_id            = aws_security_group.db_sg.id
  referenced_security_group_id = aws_security_group.api_sg.id

  ip_protocol = "tcp"
  from_port   = 5432
  to_port     = 5432

  description = "Allow PostgreSQL access from Journal API"
}

resource "aws_vpc_security_group_ingress_rule" "bastion_inbound" {
  security_group_id            = aws_security_group.db_sg.id
  referenced_security_group_id = aws_security_group.bastion_sg.id

  ip_protocol = "tcp"
  from_port   = 5432
  to_port     = 5432

  description = "Allow PostgreSQL access from Bastion host"
}

# Database Outbound Rule
resource "aws_vpc_security_group_egress_rule" "db_outbound" {
  security_group_id = aws_security_group.db_sg.id

  ip_protocol = "-1"
  cidr_ipv4   = "0.0.0.0/0"

  description = "Allow all outbound traffic"
}

# Security group for VPC endpoints
resource "aws_security_group" "vpce" {
  name        = "journal-vpce-sg"
  description = "Allow HTTPS from resources in the VPC to interface endpoints"
  vpc_id      = aws_vpc.main.id

  tags = {
    Name = "journal-vpce-sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "vpce_https" {
  security_group_id = aws_security_group.vpce.id

  ip_protocol = "tcp"
  from_port   = 443
  to_port     = 443

  cidr_ipv4 = aws_vpc.main.cidr_block
}

resource "aws_vpc_security_group_egress_rule" "vpce_all" {
  security_group_id = aws_security_group.vpce.id

  ip_protocol = "-1"
  cidr_ipv4   = "0.0.0.0/0"
}
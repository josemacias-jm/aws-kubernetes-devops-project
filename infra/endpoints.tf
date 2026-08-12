# Bedrock Interface Endpoint
resource "aws_vpc_endpoint" "bedrock_runtime" {
  vpc_id            = aws_vpc.main.id
  service_name      = "com.amazonaws.${var.region}.bedrock-runtime"
  vpc_endpoint_type = "Interface"

  subnet_ids         = [aws_subnet.app_1.id, aws_subnet.app_2.id]
  security_group_ids = [aws_security_group.vpce.id]

  private_dns_enabled = true
}

# STS Interface Endpoint for EKS IRSA
resource "aws_vpc_endpoint" "sts" {
  vpc_id              = aws_vpc.main.id
  service_name        = "com.amazonaws.${var.region}.sts"
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true

  subnet_ids = [
    aws_subnet.app_1.id,
    aws_subnet.app_2.id
  ]

  security_group_ids = [aws_security_group.vpce.id]
}

# SSM Session Manager Interface Endpoints
resource "aws_vpc_endpoint" "ssm" {
  vpc_id            = aws_vpc.main.id
  service_name      = "com.amazonaws.${var.region}.ssm"
  vpc_endpoint_type = "Interface"

  subnet_ids         = [aws_subnet.db_1.id, aws_subnet.db_2.id]
  security_group_ids = [aws_security_group.vpce.id]

  private_dns_enabled = true
}

resource "aws_vpc_endpoint" "ssmmessages" {
  vpc_id            = aws_vpc.main.id
  service_name      = "com.amazonaws.${var.region}.ssmmessages"
  vpc_endpoint_type = "Interface"

  subnet_ids         = [aws_subnet.db_1.id, aws_subnet.db_2.id]
  security_group_ids = [aws_security_group.vpce.id]

  private_dns_enabled = true
}

resource "aws_vpc_endpoint" "ec2messages" {
  vpc_id            = aws_vpc.main.id
  service_name      = "com.amazonaws.${var.region}.ec2messages"
  vpc_endpoint_type = "Interface"

  subnet_ids         = [aws_subnet.db_1.id, aws_subnet.db_2.id]
  security_group_ids = [aws_security_group.vpce.id]

  private_dns_enabled = true
}

# ECR Interface Endpoints
resource "aws_vpc_endpoint" "ecr_api" {
  vpc_id            = aws_vpc.main.id
  service_name      = "com.amazonaws.${var.region}.ecr.api"
  vpc_endpoint_type = "Interface"

  subnet_ids         = [aws_subnet.app_1.id, aws_subnet.app_2.id]
  security_group_ids = [aws_security_group.vpce.id]

  private_dns_enabled = true
}

resource "aws_vpc_endpoint" "ecr_dkr" {
  vpc_id            = aws_vpc.main.id
  service_name      = "com.amazonaws.${var.region}.ecr.dkr"
  vpc_endpoint_type = "Interface"

  subnet_ids         = [aws_subnet.app_1.id, aws_subnet.app_2.id]
  security_group_ids = [aws_security_group.vpce.id]

  private_dns_enabled = true
}

# S3 Gateway Endpoint (for ECR image pulls)
resource "aws_vpc_endpoint" "s3" {
  vpc_id            = aws_vpc.main.id
  service_name      = "com.amazonaws.${var.region}.s3"
  vpc_endpoint_type = "Gateway"

  route_table_ids = [aws_route_table.app_rt.id]
}

# EC2 Interface Endpoint (for VPC CNI and node bootstrapping)
resource "aws_vpc_endpoint" "ec2" {
  vpc_id              = aws_vpc.main.id
  service_name        = "com.amazonaws.${var.region}.ec2"
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true

  subnet_ids = [aws_subnet.app_1.id, aws_subnet.app_2.id]

  security_group_ids = [aws_security_group.vpce.id]
}

# Load Balancer Interface Endpoint
resource "aws_vpc_endpoint" "elasticloadbalancing" {
  vpc_id              = aws_vpc.main.id
  service_name        = "com.amazonaws.${var.region}.elasticloadbalancing"
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true

  subnet_ids = [aws_subnet.app_1.id, aws_subnet.app_2.id]

  security_group_ids = [aws_security_group.vpce.id]
}

# AWS X-Ray endpoint for ADOT trace export
resource "aws_vpc_endpoint" "xray" {
  vpc_id              = aws_vpc.main.id
  service_name        = "com.amazonaws.${var.region}.xray"
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true

  subnet_ids = [aws_subnet.app_1.id, aws_subnet.app_2.id]

  security_group_ids = [aws_security_group.vpce.id]
}

# CloudWatch Logs endpoint for application logs and EMF metrics
resource "aws_vpc_endpoint" "cloudwatch_logs" {
  vpc_id              = aws_vpc.main.id
  service_name        = "com.amazonaws.${var.region}.logs"
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true

  subnet_ids = [aws_subnet.app_1.id, aws_subnet.app_2.id]

  security_group_ids = [aws_security_group.vpce.id]
}
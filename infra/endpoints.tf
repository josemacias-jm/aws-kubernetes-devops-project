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
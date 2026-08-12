# Get the latest Ubuntu AMI
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# EC2 instance for Bastion host
resource "aws_instance" "bastion" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.instance_type
  associate_public_ip_address = false
  subnet_id                   = aws_subnet.db_1.id
  vpc_security_group_ids      = [aws_security_group.bastion_sg.id]
  iam_instance_profile        = aws_iam_instance_profile.bastion_ssm.name

  tags = {
    Name = "private-bastion"
  }
}

# ECR Repository for the API Docker image
resource "aws_ecr_repository" "api_repo" {
  name = "journal-app"

  image_scanning_configuration {
    scan_on_push = true
  }
}

# RDS PostgreSQL Database
resource "aws_db_instance" "postgres" {
  identifier        = "journal-db"
  engine            = "postgres"
  engine_version    = "15"
  instance_class    = "db.t3.micro"
  allocated_storage = 20

  db_name  = var.db_name
  username = var.db_username
  password = var.db_password
  port     = 5432

  publicly_accessible = false
  skip_final_snapshot = true

  vpc_security_group_ids = [aws_security_group.db_sg.id]
  db_subnet_group_name   = aws_db_subnet_group.db_subnets.name
}

resource "aws_db_subnet_group" "db_subnets" {
  name       = "journal-db-subnet-group"
  subnet_ids = [aws_subnet.db_1.id, aws_subnet.db_2.id]
}

# EKS Cluster
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 21.0"

  name               = var.cluster_name
  kubernetes_version = "1.35"

  endpoint_public_access  = true
  endpoint_private_access = true

  vpc_id = aws_vpc.main.id

  subnet_ids = [
    aws_subnet.app_1.id,
    aws_subnet.app_2.id
  ]

  control_plane_subnet_ids = [
    aws_subnet.app_1.id,
    aws_subnet.app_2.id
  ]

  addons = {
    vpc-cni = {
      before_compute = true
    }

    kube-proxy = {}

    coredns = {}
  }

  enable_irsa = true

  eks_managed_node_groups = {
    green = {
      min_size     = 1
      max_size     = 1
      desired_size = 1

      instance_types = ["t3.medium"]

      vpc_security_group_ids = [
        aws_security_group.api_sg.id
      ]
    }
  }
}
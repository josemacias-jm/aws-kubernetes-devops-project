output "ecr_repository_url" {
  value = aws_ecr_repository.api_repo.repository_url
}

output "db_connection_string" {
  description = "PostgreSQL connection string for the Journal API"

  value = format(
    "postgresql://%s:%s@%s:%s/%s",
    urlencode(var.db_username),
    urlencode(var.db_password),
    aws_db_instance.postgres.address,
    aws_db_instance.postgres.port,
    var.db_name
  )

  sensitive = true
}

output "eks_cluster_name" {
  value = module.eks.cluster_name
}

output "eks_cluster_endpoint" {
  description = "Endpoint of the EKS Kubernetes API server"
  value       = module.eks.cluster_endpoint
}

output "configure_kubectl_command" {
  description = "AWS CLI command to configure kubectl for the EKS cluster"
  value = format(
    "aws eks update-kubeconfig --region %s --name %s",
    var.region,
    module.eks.cluster_name
  )
}

output "adot_collector_role_arn" {
  value = aws_iam_role.adot_collector.arn
}
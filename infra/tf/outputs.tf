# Main
output "vpc_id" {
  value = module.vpc.vpc_id
}

output "public_subnet_ids" {
  value = module.vpc.public_subnets
}

output "private_subnet_ids" {
  value = module.vpc.private_subnets
}

output "nat_gateway_ids" {
  value = module.vpc.natgw_ids
}

# Eks
output "cluster_name" {
  value = module.eks.cluster_name
}

output "cluster_endpoint" {
  value = module.eks.cluster_endpoint
}

output "cluster_certificate_authority_data" {
  value = module.eks.cluster_certificate_authority_data
}

# Rds
output "query_results_bucket_name" {
  description = "The name of the S3 bucket for query results"
  value       = module.s3_bucket.s3_directory_bucket_name
}

output "query_results_bucket_arn" {
  description = "The ARN of the S3 bucket for query results"
  value       = module.s3_bucket.s3_bucket_arn
}

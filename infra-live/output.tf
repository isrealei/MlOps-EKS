output "address" {
  description = "The address of the database instance"
  value       = module.backend.address
}

output "db_subnet_group_name" {
  description = "The name of the DB subnet group"
  value       = module.backend.db_subnet_group_name
}

output "db_instance_id" {
  description = "The ID of the DB instance"
  value       = module.backend.db_instance_id
}


output "db_instance_endpoint" {
  description = "The endpoint of the DB instance"
  value       = module.backend.db_instance_endpoint
}

output "arn" {
  description = "value of the arn"
  value       = module.backend.arn
}

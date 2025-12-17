variable "environment" {
  type        = string
  description = "value for environment"
}

variable "vpc_name" {
  type        = string
  description = "value for vpc name"
}

variable "cluster_name" {
  type        = string
  description = "value for cluster name"
}

variable "availability_zones" {
  type        = list(string)
  description = "values for availability zones"
}

variable "cidr_block" {
  type        = string
  description = "value"
}

variable "private_subnets_cidr" {
  type        = list(string)
  description = "values for private subnets cidr"
}

variable "public_subnets_cidr" {
  type        = list(string)
  description = "values for public subnets cidr"
}

variable "db_subnets_cidr" {
  type        = list(string)
  description = "values for database subnets cidr"

}

variable "create_for_eks" {
  type    = bool
  default = true
}

variable "eks_version" {
  description = "value for eks version"
  type        = string
}

variable "node_groups" {
  type = map(object({
    instance_types = list(string)
    capacity_type  = string
    scaling_config = object({
      desired_size = number
      max_size     = number
      min_size     = number
    })
  }))
  description = "Map of node groups with their configurations"
  default     = {}
}

variable "project" {
  type        = string
  description = "value for project"
}

variable "database_config" {
  description = "Database configuration for the application"
  sensitive   = true
  type = object({
    db_name           = string
    db_username       = string
    db_password       = string
    db_instance_class = string
    db_engine         = string
    db_engine_version = string
    project_name      = string
  })
}

variable "region" {
  type = string
}

variable "admin_arn" {
  type = string
}
variable "mlflow_db_password" {
  type      = string
  sensitive = true
}

variable "myip" {
  type = list(string)
}
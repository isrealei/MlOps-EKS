
variable "node_groups" {
  description = "EKS node group"
  type = map(object({
    instance_types = list(string)
    capacity_type  = string
    scaling_config = object({
      desired_size = number
      max_size     = number
      min_size     = number
    })
  }))
}

variable "subnet_ids" {
  type = list(string)
}

variable "eks_version" {
  type = string
}

variable "cluster_name" {
  type = string
}

variable "environment" {
  type = string
}

variable "admin_arn" {
  type = string
}
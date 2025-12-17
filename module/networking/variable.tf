
variable "region" {
  type    = string
  default = "us-east-1"
}

variable "cidr_block" {
  type = string
}

variable "availability_zones" {
  type = list(string)
}

variable "environment" {
  type = string
}

variable "project" {
  type = string
}

variable "vpc_name" {
  type = string
}

variable "private_subnets_cidr" {
  type = list(string)
}

variable "cluster_name" {
  type = string
}

variable "create_for_eks" {
  type    = bool
  default = true
}

variable "public_subnets_cidr" {
  type = list(string)
}

variable "db_subnets_cidr" {
  description = "This is the list of database subnets"
  type        = list(string)
}

variable "myip" {
  type = list(string)
}
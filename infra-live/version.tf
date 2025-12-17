terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.26.0"
    }
    # helm = {
    #   source  = "hashicorp/helm"
    #   version = "3.1.1"
    # }
    kubectl = {
      source  = "kahirokunn/kubectl"
      version = "1.13.11"
    }
    postgresql = {
      source  = "cyrilgdn/postgresql"
      version = "1.26.0"
    }
  }
}

provider "aws" {
  region = var.region
}

provider "helm" {
  kubernetes {
    # Use the EKS cluster endpoint and CA certificate to configure the Helm provider{
    host                   = module.eks.cluster_endpoint
    cluster_ca_certificate = base64decode(module.eks.cluster_ca_certificate)
    token                  = data.aws_eks_cluster_auth.cluster.token
  }
}


provider "kubernetes" {
  host                   = module.eks.cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks.cluster_ca_certificate)
  token                  = data.aws_eks_cluster_auth.cluster.token
}

provider "kubectl" {
  host                   = module.eks.cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks.cluster_ca_certificate)
  token                  = data.aws_eks_cluster_auth.cluster.token
  load_config_file       = false
}

provider "postgresql" {
  host            = module.backend.address
  port            = 5432
  username        = var.database_config.db_username
  password        = var.database_config.db_password
  sslmode         = "require"
  superuser       = false
  connect_timeout = 15
}


data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_name
}


data "aws_region" "current" {}
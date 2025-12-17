#########################################################################################################
#                                      VPC    PROVISIONING                                               #
#########################################################################################################
module "vpc" {
  source = "../module/networking"

  environment          = var.environment
  vpc_name             = var.vpc_name
  cluster_name         = var.cluster_name
  availability_zones   = var.availability_zones
  cidr_block           = var.cidr_block
  private_subnets_cidr = var.private_subnets_cidr
  public_subnets_cidr  = var.public_subnets_cidr
  db_subnets_cidr      = var.db_subnets_cidr
  create_for_eks       = true
  project              = var.project
  myip                 = var.myip
}


#########################################################################################################
#                                      EKS  PROVISIONING                                               #
#########################################################################################################
module "eks" {
  source       = "../module/eks"
  depends_on   = [module.vpc]
  cluster_name = var.cluster_name
  eks_version  = var.eks_version
  subnet_ids   = module.vpc.private_subnet_ids
  node_groups  = var.node_groups
  admin_arn    = var.admin_arn
  environment  = var.environment
}

#########################################################################################################
#                                      EKS BLUEPRINT FOR INSTALLING CLUSTER ADDONS                      #
#########################################################################################################
module "eks_blueprints_addons" {
  source     = "aws-ia/eks-blueprints-addons/aws"
  version    = "1.23.0"
  depends_on = [module.eks]

  cluster_name      = module.eks.cluster_name
  cluster_endpoint  = module.eks.cluster_endpoint
  cluster_version   = module.eks.cluster_version
  oidc_provider_arn = module.eks.oidc_provider_arn

  eks_addons = {
    # aws-ebs-csi-driver = {
    #   most_recent = true
    # }
  }

  enable_aws_load_balancer_controller = true
  aws_load_balancer_controller = {
    set = [
      { name  = "vpcId"
        value = module.vpc.vpc_id
      }
    ]
  }

  enable_kube_prometheus_stack = true
  enable_metrics_server        = true
  enable_argocd                = true
  tags = {
    Environment = var.environment
  }
}


#########################################################################################################
#                                      DATABASE AND CACHE PROVISIONING                                  #
#########################################################################################################
# this  module will create postgress and redis
module "backend" {
  source = "../module/database"

  vpc_id            = module.vpc.vpc_id
  db_name           = var.database_config.db_name
  db_username       = var.database_config.db_username
  db_password       = var.database_config.db_password
  db_instance_class = var.database_config.db_instance_class
  db_engine         = var.database_config.db_engine
  db_engine_version = var.database_config.db_engine_version
  db_subnet_ids     = module.vpc.db_subnet_ids
  env               = var.environment
  project_name      = var.database_config.project_name
  db_security_group = module.vpc.db_security_group_id

  depends_on = [module.vpc]

}

########################################################################################################
resource "postgresql_role" "mlflow_user" {
  name     = "mlflow_user"
  login    = true
  password = var.mlflow_db_password
}

resource "postgresql_database" "mlflow" {
  name  = "mlflow"
  owner = postgresql_role.mlflow_user.name
}

resource "postgresql_grant" "mlflow_db_privileges" {
  database    = postgresql_database.mlflow.name
  role        = postgresql_role.mlflow_user.name
  object_type = "database"
  privileges  = ["ALL"]
}

resource "postgresql_grant" "mlflow_schema_privileges" {
  database    = postgresql_database.mlflow.name
  role        = postgresql_role.mlflow_user.name
  schema      = "public"
  object_type = "schema"
  privileges  = ["ALL"]
}

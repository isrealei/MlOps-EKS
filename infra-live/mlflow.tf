resource "kubernetes_namespace" "mlflow" {
  metadata {
    name = "mlflow"
  }
}


resource "helm_release" "mlflow" {
  name       = "mlflow"
  namespace  = kubernetes_namespace.mlflow.metadata[0].name
  repository = "https://community-charts.github.io/helm-charts"
  chart      = "mlflow"
  version    = "0.7.19" # pin this; update intentionally

  create_namespace = false

  set {
    name  = "backendStore.databaseMigration"
    value = "true"
  }

  set {
    name  = "backendStore.postgres.enabled"
    value = "true"
  }

  set {
    name  = "backendStore.postgres.host"
    value = module.backend.address
  }

  set {
    name  = "backendStore.postgres.port"
    value = "5432"
  }

  set {
    name  = "backendStore.postgres.database"
    value = "mlflow"
  }

  set {
    name  = "backendStore.postgres.user"
    value = "mlflow_user"
  }

  set_sensitive {
    name  = "backendStore.postgres.password"
    value = var.mlflow_db_password
  }

  depends_on = [
    kubernetes_namespace.mlflow
  ]
}

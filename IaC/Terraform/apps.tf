resource "helm_release" "mysql" {
  name             = "mysql"
  namespace        = "laravel"
  repository       = "https://charts.bitnami.com/bitnami"
  chart            = "mysql"
  version          = "9.2.0"
  atomic           = true
  create_namespace = true

  values = [
    templatefile("${path.module}/helm-values/mysql.yaml", {
        rootPassword  = var.mysql.rootPassword
        username      = var.mysql.username
        password      = var.mysql.password
        size          = var.mysql.size
        initdbScripts = var.mysql.initdbScripts
        path          = path.module
      }
    )
  ]
}

resource "helm_release" "redis" {
  name             = "redis"
  namespace        = "laravel"
  repository       = "https://charts.bitnami.com/bitnami"
  chart            = "redis"
  version          = "17.0.1"
  atomic           = true
  create_namespace = true

  values = [templatefile("${path.module}/helm-values/redis.yaml", {})]
}

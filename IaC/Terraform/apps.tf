resource "helm_release" "mysql" {
  name             = "mysql"
  namespace        = "laravel"
  repository       = "https://charts.bitnami.com/bitnami"
  chart            = "mysql"
  version          = "9.2.0"
  atomic           = true
  create_namespace = true
  depends_on       = [aws_eks_cluster.default]

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
  depends_on       = [aws_eks_cluster.default]

  values = [templatefile("${path.module}/helm-values/redis.yaml", {})]
}

resource "helm_release" "laravel" {
  name             = "laravel"
  namespace        = "laravel"
  repository       = "${path.module}/helm-charts"
  chart            = "laravel"
  atomic           = true
  create_namespace = true
  depends_on       = [
    aws_eks_cluster.default,
    helm_release.redis,
  ]
}

resource "helm_release" "wordpress" {
  name             = "wordpress"
  namespace        = "laravel"
  repository       = "https://charts.bitnami.com/bitnami"
  chart            = "wordpress"
  version          = "15.0.12"
  atomic           = true
  create_namespace = true
  depends_on       = [
    aws_eks_cluster.default,
    helm_release.mysql,
  ]

  values = [
    templatefile("${path.module}/helm-values/wordpress.yaml", {
        username      = var.mysql.username
        password      = var.mysql.password
      }
    )
  ]
}

provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}

provider "kubernetes" {
  config_path = "~/.kube/config"
}

resource "kubernetes_namespace" "online_boutique" {
  metadata {
    name = "online-boutique"
  }
}

resource "helm_release" "online_boutique" {
  name       = "online-boutique"
  chart      = "${path.module}/microservices-demo/helm-chart"
  version    = "0.10.2"
  namespace  = "online-boutique"
  force_update = true
}
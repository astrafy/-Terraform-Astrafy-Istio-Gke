data "google_client_config" "default" {}

resource "helm_release" "istio_base" {
  name       = "istio-base"
  repository = "https://istio-release.storage.googleapis.com/charts"
  chart      = "base"
  version    = "1.14.1"
  namespace  = kubernetes_namespace.istio_system.metadata.0.name

}

resource "helm_release" "istio_discovery" {
  name       = "istiod"
  repository = "https://istio-release.storage.googleapis.com/charts"
  chart      = "istiod"
  version    = "1.14.1"
  namespace  = kubernetes_namespace.istio_system.metadata.0.name

  depends_on = [helm_release.istio_base]
}

resource "helm_release" "istio_ingress" {
  name       = "istio-ingress"
  repository = "https://istio-release.storage.googleapis.com/charts"
  chart      = "gateway"
  version    = "1.14.1"
  namespace  = kubernetes_namespace.istio_ingress.metadata.0.name

  values = [
    file("${path.module}/istio/ingress.yaml")
  ]
  depends_on = [helm_release.istio_discovery]
}

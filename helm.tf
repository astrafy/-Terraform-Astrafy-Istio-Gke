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

}

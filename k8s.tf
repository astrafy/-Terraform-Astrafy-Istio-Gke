resource "kubernetes_namespace" "istio_system" {
  metadata {
    name = "istio-system"
  }
}

resource "kubernetes_namespace" "istio_ingress" {
  metadata {
    name = "istio-ingress"
    labels = {
      istio-injection = "enabled"
    }
  }
}

resource "kubernetes_ingress" "istio" {
  metadata {
    name      = "istio-ingress"
    namespace = kubernetes_namespace.istio_ingress.metadata.0.name
    annotations = {
      "networking.gke.io/managed-certificates"      = google_compute_managed_ssl_certificate.istio_ingress_lb.certificate_id
      "kubernetes.io/ingress.global-static-ip-name" = google_compute_global_address.istio_ingress_lb_ip.name
      "kubernetes.io/ingress.allow-http"            = var.istio_ingress_configuration.allow_http
    }
  }
  spec {
    dynamic "rule" {
      for_each = [for host in var.istio_ingress_configuration.hosts : {
        host = host
      }]
      content {
        host = rule.value.host
        http {
          path {
            backend {
              service_name = helm_release.istio_ingress.name # Set as service name
              service_port = 80
            }
          }
        }
      }
    }
  }
  depends_on = [helm_release.istio_ingress]
}

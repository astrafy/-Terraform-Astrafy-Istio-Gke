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

resource "kubernetes_ingress_v1" "istio" {
  metadata {
    name      = "istio-ingress"
    namespace = kubernetes_namespace.istio_ingress.metadata.0.name
    annotations = {
      "networking.gke.io/managed-certificates"      = kubernetes_manifest.istio_managed_certificate.manifest.metadata.name
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
              service {
                name = helm_release.istio_ingress.name # Set as service name
                port {
                  number = 80
                }
              }
            }
          }
        }
      }
    }
  }
  depends_on = [helm_release.istio_ingress]
}

resource "kubernetes_manifest" "istio_managed_certificate" {
  manifest = {
    apiVersion = "networking.gke.io/v1"
    kind       = "ManagedCertificate"
    metadata = {
      name      = random_id.istio_ingress_lb_certificate.hex
      namespace = kubernetes_namespace.istio_ingress.metadata.0.name
    }
    spec = {
      domains = var.istio_ingress_configuration.hosts
    }
  }
}

resource "kubernetes_manifest" "istio_gateway" {
  manifest = {
    apiVersion = "networking.istio.io/v1alpha3"
    kind       = "Gateway"
    metadata = {
      name      = "istio-gateway"
      namespace = kubernetes_namespace.istio_ingress.metadata.0.name
    }
    spec = {
      selector = {
        istio = "ingress"
      }
      servers = [
        {
          hosts = ["*"]
          port = {
            name     = "http"
            number   = 80
            protocol = "HTTP"
          }
        }
      ]
    }
  }
}

resource "kubernetes_manifest" "istio_virtual_service_health_check" {
  manifest = {
    apiVersion = "networking.istio.io/v1alpha3"
    kind       = "VirtualService"
    metadata = {
      name      = "health"
      namespace = kubernetes_namespace.istio_ingress.metadata.0.name
    }
    spec = {
      gateways = [
        kubernetes_manifest.istio_gateway.manifest.metadata.name
      ]
      hosts = [
        "*"
      ]
      http = [
        {
          match = [
            {
              headers = {
                user-agent = {
                  prefix = "GoogleHC"
                }
              }
              method = {
                exact = "GET"
              }
              uri = {
                exact = "/"
              }
            }
          ]
          rewrite = {
            authority = "${helm_release.istio_ingress.name}.${kubernetes_namespace.istio_ingress.metadata.0.name}.svc.cluser.local:15021"
            uri       = "/healthz/ready"
          }
          route = [
            {
              destination = {
                host = "${helm_release.istio_ingress.name}.${kubernetes_namespace.istio_ingress.metadata.0.name}.svc.cluser.local"
                port = {
                  number = 15021
                }
              }
            }
          ]
        }
      ]
    }
  }
}

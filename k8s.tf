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
      "networking.gke.io/managed-certificates"      = join(",", [for managed_cert in kubernetes_manifest.istio_managed_certificate : managed_cert.manifest.metadata.name])
      "kubernetes.io/ingress.global-static-ip-name" = google_compute_global_address.istio_ingress_lb_ip.name
      "kubernetes.io/ingress.allow-http"            = var.istio_ingress_configuration.allow_http
    }
  }
  spec {
    dynamic "rule" {
      for_each = [for host in var.istio_ingress_configuration.hosts : {
        host            = host.host
        backend_service = host.backend_service
      }]
      content {
        host = rule.value.host
        http {
          path {
            backend {
              service {
                name = coalesce(rule.value.backend_service, "istio-ingress") # Set as service name
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

}

resource "kubernetes_manifest" "istio_managed_certificate" {
  for_each = toset([for host in var.istio_ingress_configuration.hosts : host.host])
  manifest = {
    apiVersion = "networking.gke.io/v1"
    kind       = "ManagedCertificate"
    metadata = {
      name      = random_id.istio_ingress_lb_certificate[each.value].hex
      namespace = kubernetes_namespace.istio_ingress.metadata.0.name
    }
    spec = {
      domains = [each.value]
    }
  }
}

resource "kubernetes_manifest" "istio_gateway" {
  count = var.use_crds ? 1 : 0
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

resource "kubernetes_manifest" "backend_config" {
  manifest = {
    apiVersion = "cloud.google.com/v1"
    kind       = "BackendConfig"
    metadata = {
      name      = "ingress-backendconfig"
      namespace = kubernetes_namespace.istio_ingress.metadata.0.name
    }
    spec = {
      healthCheck = {
        requestPath = "/healthz/ready"
        port        = 15021
        type        = "HTTP"
      }
    }
  }
}

resource "kubernetes_manifest" "istio_virtual_services" {
  for_each = var.virtual_services
  manifest = {
    apiVersion = "networking.istio.io/v1alpha3"
    kind       = "VirtualService"
    metadata = {
      name      = each.key
      namespace = each.value.target_namespace
    }
    spec = {
      gateways = [
        "${kubernetes_namespace.istio_ingress.metadata.0.name}/${kubernetes_manifest.istio_gateway[0].manifest.metadata.name}"
      ]
      hosts = each.value.hosts
      http = [
        {
          match = [
            {
              uri = {
                prefix = "/"
              }
            }
          ]
          route = [
            {
              destination = {
                host = "${each.value.target_service}.${each.value.target_namespace}.svc.cluster.local"
                port = {
                  number = each.value.port_number
                }
              }
            },
          ]
        }
      ]
    }
  }
}

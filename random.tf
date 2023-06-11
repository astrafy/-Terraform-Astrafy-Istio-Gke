resource "random_id" "istio_ingress_lb_certificate" {
  byte_length = 4
  prefix      = "istio-ingress-lb-cert"
  keepers = {
    domains = join(",", [for host in var.istio_ingress_configuration.hosts : host.host])
  }
}

resource "random_id" "istio_ingress_lb_certificate" {
  for_each    = toset([for host in concat(var.istio_ingress_configuration.hosts, var.istio_ingress_configuration.hosts_iap) : host.host])
  byte_length = 4
  prefix      = "istio-ingress-lb-cert-${each.value}"
}

resource "google_compute_global_address" "istio_ingress_lb_ip" {
  name = var.address_name != "" ? "istio-ingress-lb-ip-${var.address_name}" : "istio-ingress-lb-ip"
}

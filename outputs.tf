output "istio_ingress_lb_ip" {
  value       = google_compute_global_address.istio_ingress_lb_ip.address
  description = "Public IP of the L7 load balancer"
}

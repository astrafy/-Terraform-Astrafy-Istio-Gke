resource "google_compute_firewall" "gke_master_istio_pilot_allow" {
  count     = var.private_cluster ? 1 : 0
  name      = "istio-pilot-discovery-allow"
  network   = var.vpc_network_id
  direction = "INGRESS"
  allow {
    protocol = "tcp"
    ports    = ["15017"]
  }
  target_tags   = var.cluster_node_network_tags
  source_ranges = [var.master_cidr_range]
}

resource "google_compute_global_address" "istio_ingress_lb_ip" {
  name = "istio-ingress-lb-ip"
}

resource "google_compute_managed_ssl_certificate" "istio_ingress_lb" {
  name        = random_id.istio_ingress_lb_certificate.hex
  description = "Google-managed SSL certificate for the Istio ingress Load Balancer (L7)"

  lifecycle {
    create_before_destroy = true
  }

  managed {
    domains = var.istio_ingress_configuration.hosts
  }
}

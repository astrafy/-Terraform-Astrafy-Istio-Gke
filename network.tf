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

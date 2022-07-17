terraform {
  required_version = ">= 1.2.4"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.28.0"
    }
    google-beta = {
      source  = "hashicorp/google-beta"
      version = "4.28.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.12.1"
    }
  }
  cloud {
    organization = "astrafy"

    workspaces {
      name = "istio-gke-tmp"
    }
  }
}

provider "google" {
  # Configuration options
  project = var.project_id_gke
}

provider "google-beta" {
  # Configuration options
}

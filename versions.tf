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
    helm = {
      source  = "hashicorp/helm"
      version = "2.6.0"
    }
  }
  cloud {
    organization = "astrafy"

    workspaces {
      name = "istio-gke-tmp"
    }
  }
}


provider "helm" {
  # Configuration options
  kubernetes { # TODO : use token, via root module
    host  = var.cluster_host
    token = data.google_client_config.default.access_token
  }
}
provider "google" {
  # Configuration options
  project = var.project_id_gke
}

provider "google-beta" {
  # Configuration options
}

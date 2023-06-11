terraform {
  required_version = ">= 1.3.0"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">=4.28.0"
    }
    google-beta = {
      source  = "hashicorp/google-beta"
      version = ">=4.28.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">=2.12.1"
    }
    helm = {
      source  = "hashicorp/helm"
      version = ">=2.6.0"
    }
    random = {
      source  = "hashicorp/random"
      version = ">=3.0.0"
    }
  }
}

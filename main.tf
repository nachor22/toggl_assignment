variable "project" {
  description = "Project id"
}

variable "region" {
  description = "GCP region to be used"
  default = "us-central1"
}

variable "zone" {
  description = "GCP zone to be used"
  default = "us-central1-a"
}

variable "zone_consul" {
  description = "GCP zone to deploy consul cluster"
  default = "us-east1-b"
}

variable "dns_zone" {
  description = "DNS zone to manage"
  default = "nachor22.tk"
}

provider "google" {
  project     = var.project
  region      = var.region
  zone        = var.zone
}

variable "project" {
  description = "Project id"
}

variable "region" {
  default = "us-central1"
}

variable "zone" {
  default = "us-central1-a"
}

variable "zone_consul" {
  default = "us-east1-b"
}

provider "google" {
  project     = var.project
  region      = var.region
  zone        = var.zone
}

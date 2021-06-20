#enable GCP apis
resource "google_project_service" "crm" {
  service = "cloudresourcemanager.googleapis.com"
  disable_on_destroy = false
}

resource "google_project_service" "iam" {
  service = "iam.googleapis.com"
  disable_on_destroy = false
}

resource "google_project_service" "compute" {
  service = "compute.googleapis.com"
  disable_on_destroy = false
}

resource "google_project_service" "dns" {
  service = "dns.googleapis.com"
  disable_on_destroy = false
}

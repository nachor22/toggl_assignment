#public storage for static content
resource "google_storage_bucket" "public" {
  name        = "toggl-public"
}

resource "google_storage_default_object_access_control" "public_rule" {
  bucket = google_storage_bucket.public.name
  role   = "READER"
  entity = "allUsers"
}

resource "google_storage_bucket_object" "index" {
  name   = "index.html"
  source = "data/SRE_Assignment/public/index.html"
  bucket = google_storage_bucket.public.name
  depends_on = [google_storage_default_object_access_control.public_rule]
}

resource "google_storage_bucket_object" "main" {
  name   = "main.js"
  source = "data/SRE_Assignment/public/main.js"
  bucket = google_storage_bucket.public.name
  depends_on = [google_storage_default_object_access_control.public_rule]
}

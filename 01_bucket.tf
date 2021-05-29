resource "google_storage_bucket" "static_content" {
  name        = "static_content"
}

resource "google_storage_bucket_object" "index" {
  name   = "intex.html"
  source = "public/index.html"
  bucket = "static_content"
}

resource "google_storage_bucket_object" "main" {
  name   = "main.js"
  source = "public/main.js"
  bucket = "static_content"
}
